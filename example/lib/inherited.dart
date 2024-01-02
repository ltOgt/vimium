import 'dart:async';

import 'package:flutter/material.dart';

/// {@template overlayManager}
/// Object that manages the [OverlayEntry] around [overlayBuilder]
///
///
/// Can be used like so:
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
///  // Be aware: passing [this] (Ticker) as `late` can lead to issues if [_anim]/[_launcher]
///  // is never used!
///  // In those cases, we would only initialize it at [dispose], which is illegal,
///  // because the ticker looks up ancestors (which may not be done in dispose).
///  // So for these cases, initialize in [initState] instead
///  final _anim = AnimationController(
///    vsync: this,
///    duration: const Duration(milliseconds: 150),
///  );
///  late final _overlay = OverlayManager(
///    animationController: _anim,
///    overlayBuilder: (c) => MyWidget(animationController: _anim),
///   );
///
///  @override
///  void dispose() {
///    _anim.dispose();
///    _overlay.dispose();
///    super.dispose();
///  }
///
///  Widget build(context) => Button(
///     onPressed: _overlay.toggle(context),
///  );
/// ```
/// {@endtemplate}
class OverlayManager {
  /// The entry holding the overlay UI
  late final OverlayEntry _overlayEntry;

  /// The [WidgetBuilder] defining the content of the overlay.
  final WidgetBuilder overlayBuilder;

  /// Optional [AnimationController] that can be used to animate in/out the [overlayBuilder].
  ///
  /// Needs to be utilized by [overlayBuilder], only driven by [OverlayManager].
  final AnimationController? animationController;

  late final Set<WillOverlayDismissCallback> _dismissCallbacks;

  /// {@macro overlayManager}
  OverlayManager({
    required this.overlayBuilder,
    this.animationController,
    WillOverlayDismissCallback? onDismiss,
  }) {
    _dismissCallbacks = {};
    if (onDismiss != null) {
      _dismissCallbacks.add(onDismiss);
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => _OverlayManagerScope._(
        dismissCallbacks: _dismissCallbacks,
        child: overlayBuilder(context),
      ),
    );
  }

  /// Call inside [State.dispose].
  void dispose() {
    if (_isOverlayVisible) {
      _overlayEntry.remove();
    }
    _overlayEntry.dispose();
  }

  // ============================================================================

  /// Whether the overlay is already inserted
  bool get isOverlayVisible => _isOverlayVisible;
  bool _isOverlayVisible = false;

  /// Completer that completes AFTER the latest ongoing animation.
  /// See [_wrapWithCompleter]
  ///
  /// Multiple completers may be set up for edge cases with many consecutive calls to [_wrapWithCompleter].
  /// (E.g. call to [show] that triggers an animation, followed by call to [hide] before animation completes).
  ///
  /// This field here holds only the latest completer, which should be used by [_executeAfterAnimationIfLatest]
  /// to await the newest animation future at any point.
  Completer? _latestAnimationCompleter;

  /// Timestamp to check if a given call to [show] or [hide] was the latest call.
  ///
  /// This is needed, since we might need to ignore a [show] after waiting for its [_latestAnimationCompleter],
  /// in case a subsequent [hide] was called before that completion.
  DateTime? lastCalledAt;

  // ignore: invalid_use_of_protected_member
  void setState(BuildContext context) => Overlay.of(context).setState(() {});

  /// Show the overlay if hidden,
  /// Hide the overlay if shown.
  Future<void> toggle(BuildContext context) async {
    if (!_isOverlayVisible) {
      show(context);
    } else {
      await hide(context);
    }
  }

  /// Show the overlay iff hidden.
  ///
  /// Completes without delay if [animationController] is null.
  /// Else, completes after [animationController.forward].
  ///
  /// Set [rootOverlay] to true to get the furthes [Overlay] instead of the nearest.
  Future<void> show(BuildContext context, {bool rootOverlay = false}) => _executeAfterAnimationIfLatest(() async {
        if (!_isOverlayVisible) {
          Overlay.of(context, rootOverlay: rootOverlay).insert(_overlayEntry);

          /// Need to explicitly check if the animationController is null before awaiting
          /// Otherwise we introduce a delay in the null case which can mess with setState timings
          /// (https://dart-lang.github.io/linter/lints/await_only_futures.html)
          if (animationController != null) {
            await _forward(animationController!);
          }

          _isOverlayVisible = true;
        }
      });

  /// Hide the overlay iff shown.
  ///
  /// Completes without delay if [animationController] is null.
  /// Else, completes after [animationController.reverse].
  Future<void> hide(BuildContext context) => _executeAfterAnimationIfLatest(() async {
        if (_isOverlayVisible) {
          await Future.wait(
            _dismissCallbacks.map(
              (dismissCallbacks) async => await dismissCallbacks(),
            ),
          );

          /// Need to explicitly check if the animationController is null before awaiting
          /// Otherwise we introduce a delay in the null case which can mess with setState timings
          /// (https://dart-lang.github.io/linter/lints/await_only_futures.html)
          if (animationController != null) {
            await _reverse(animationController!);
          }
          _overlayEntry.remove();
          _isOverlayVisible = false;
        }
      });

  Future<void> _forward(AnimationController ctrl) => _wrapWithCompleter(() => ctrl.forward());
  Future<void> _reverse(AnimationController ctrl) => _wrapWithCompleter(() => ctrl.reverse());

  /// This sets up an [_animationCompleter] which can be listened to inside [_executeAfterAnimationIfLatest].
  ///
  /// This is a seperate future from the [animation] to ensure this code here executes first.
  Future<void> _wrapWithCompleter(TickerFuture Function() animation) async {
    /// Sets up a local reference to a completer that belongs to THIS call of the function
    final completerForThisAnimation = Completer();

    /// Stores a reference to the local completer.
    /// This will be used by [_executeAfterAnimationIfLatest] to await ongoing animations
    /// In case [_wrapWithCompleter] is called again before the [animation] completes,
    /// subsequent calls to [_executeAfterAnimationIfLatest] will instead wait for that new call.
    /// The local completer will be completed by each call that created the completer.
    _latestAnimationCompleter = completerForThisAnimation;

    /// Await the actual animation before completing
    await animation();

    /// Complete the local completer which may or may not be [_latestAnimationCompleter]
    completerForThisAnimation.complete();
  }

  /// The animation of the overlay may not be completed before the opposite action is triggered.
  /// (E.g. animated open followed directly by an animated close)
  ///
  /// This can lead to undesired states.
  ///
  /// To circumvent this, we
  /// 1) wait on the ongoing animation
  /// 2) keep track of whether this call is the latest, ignoring it if not
  Future<void> _executeAfterAnimationIfLatest(FutureOr<void> Function() f) async {
    /// No need to do anything if the [animationController] is null.
    if (animationController == null) return f();

    /// represents THIS exectution.
    ///
    /// is in the scope of THIS execution.
    DateTime calledAt = DateTime.now();

    /// represents the latest execution
    ///
    /// is in the scope of the entire object
    ///
    /// - this is the same as [calledAt] iff no other execution follows THIS execution.
    /// - this differs from [calledAt] iff another execution follows THIS execution
    ///   - in this case [lastCalledAt] will be the same as THAT executions [calledAt]
    lastCalledAt = calledAt;

    /// Await the [_animationCompleter] (meaning an ongoing animation)
    if (_latestAnimationCompleter != null) {
      await _latestAnimationCompleter!.future;
    }

    /// Check if THIS is still the latest execution that was called
    /// Ignore if a newer [lastCalledAt] was set by ANOTHER call
    bool isLastRegisteredAction = (calledAt == lastCalledAt);
    if (isLastRegisteredAction) {
      return f();
    }
  }
}

typedef WillOverlayDismissCallback = Future<void> Function();

class _OverlayManagerScope extends InheritedWidget {
  final Set<WillOverlayDismissCallback> _dismissCallbacks;

  const _OverlayManagerScope._({
    required Set<WillOverlayDismissCallback> dismissCallbacks,
    required super.child,
  }) : _dismissCallbacks = dismissCallbacks;

  static _OverlayManagerScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_OverlayManagerScope>();
  }

  void addDismissCallback(WillOverlayDismissCallback callback) {
    _dismissCallbacks.add(callback);
  }

  void removeDismissCallback(WillOverlayDismissCallback callback) {
    _dismissCallbacks.remove(callback);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

/// Registers a callback which is triggered right before child overlay's dismissal.
///
/// Only works for [Overlay]s created via [OverlayManager].
class WillDismissOverlayManagerScope extends StatefulWidget {
  const WillDismissOverlayManagerScope({
    super.key,
    required this.onDismiss,
    required this.child,
  });

  final WillOverlayDismissCallback onDismiss;
  final Widget child;

  @override
  State<WillDismissOverlayManagerScope> createState() => _WillDismissOverlayManagerScopeState();
}

class _WillDismissOverlayManagerScopeState extends State<WillDismissOverlayManagerScope> {
  _OverlayManagerScope? _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope?.removeDismissCallback(widget.onDismiss);
    _scope = _OverlayManagerScope.of(context);
    _scope?.addDismissCallback(widget.onDismiss);
  }

  @override
  void didUpdateWidget(covariant WillDismissOverlayManagerScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.onDismiss != widget.onDismiss) {
      _scope?.removeDismissCallback(oldWidget.onDismiss);
      _scope?.addDismissCallback(widget.onDismiss);
    }
  }

  @override
  void dispose() {
    _scope?.removeDismissCallback(widget.onDismiss);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
