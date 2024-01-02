import 'package:flutter/material.dart';
import 'package:vimium/vimium.dart';

mixin VimiumNode<T extends StatefulWidget> on State<T> {
  bool get isEnabled;
  void onChangedEnabled() {
    if (isEnabled) {
      register(this, context);
    } else {
      unRegister(this, context);
    }
  }

  /// Keeping the reference to the scope for cleanup
  VimiumScopeInherited? _scope;

  /// Keeping track of in-progress matchings of user input to [_label] of this node.
  VimiumLabelMatchState? get matchState => _matchState;
  VimiumLabelMatchState? _matchState;

  /// The label that defines what the user must type to match, and what consitutes a [_matchState]
  VimiumLabelBase? _label;

  /// Add a [label] for this node, which will trigger [onSelected] on match.
  void addLabel(VimiumLabelBase label) {
    setState(() {
      this._label = label;
    });
  }

  /// Remove the label for this node
  void clearLabel() {
    setState(() {
      this._label = null;
      this._matchState = null;
    });
  }

  /// React to a [keyEvent] passed from the ancestor [VimiumScopeManager],
  /// and check if the [_label] is matched (partially or fully).
  VimiumLabelMatchKind? handleKeyEvent(KeyEvent keyEvent) {
    final char = keyEvent.character?.toUpperCase();
    if (_label == null || char == null) return null;

    setState(() {
      _matchState = _label!.matchKey(char, _matchState);
    });

    if (_matchState?.kind == VimiumLabelMatchKind.full) {
      onSelected();
    }
    return _matchState?.kind;
  }

  /// Register with the ancestor [VimiumScopeManager].
  ///
  /// This allows for [addLabel], [handleKeyEvent] etc to be called.
  bool register(VimiumNode self, BuildContext context) {
    _scope = VimiumScopeInherited.of(context);
    if (_scope == null) {
      assert(false, "No VimiumScope found in context");
      return false;
    }

    return _scope!.vimiumScopeManager.register(self);
  }

  /// Unregister from the ancestor [VimiumScopeManager]
  bool unRegister(VimiumNode self, BuildContext context) {
    if (_scope == null) return false;

    final manager = _scope!.vimiumScopeManager;
    _scope = null;
    return manager.unRegister(self);
  }

  @override
  void didChangeDependencies() {
    register(this, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    unRegister(this, context);
    super.dispose();
  }

  Widget buildWrapper(Widget child) => _label == null //
      ? child
      : buildLabelWrap(child, _label!.value, _matchState);

  // =============================================================================

  /// Need to build when [label] is not null
  Widget buildLabelWrap(
    Widget child,
    String labelValue,
    VimiumLabelMatchState? matchState,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Center(
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                color: switch (matchState?.kind) {
                  null => Colors.yellow,
                  VimiumLabelMatchKind.partial => Colors.blue,
                  VimiumLabelMatchKind.full => Colors.red,
                },
                boxShadow: const [BoxShadow()],
              ),
              child: Text(
                labelValue,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Called when the user selected the object via vimium text ovleray
  void onSelected();
}
