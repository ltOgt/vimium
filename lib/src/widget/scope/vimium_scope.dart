import 'package:flutter/material.dart';
import 'package:vimium/src/label/labeling/labeling_factory_base.dart';
import 'package:vimium/src/label/labeling/labeling_factory_two_keys.dart';

import 'package:vimium/src/widget/scope/vimium_scope_inherited.dart';
import 'package:vimium/src/widget/scope/vimium_scope_manager.dart';

/// The root of a sub-tree under which [VimiumNode]s can register to this scope.
class VimiumScope extends StatefulWidget {
  const VimiumScope({
    super.key,
    required this.isOverlayShown,
    required this.onMatched,
    required this.child,
    this.labelingFactory = const LabelingFactoryTwoKeys(),
  });

  /// Whether the [VimiumLabel]s for the registered [VimiumNode]s are shown.
  final bool isOverlayShown;

  /// Called when a [VimiumLabel] has been matched for a [VimiumNode].
  final VoidCallback onMatched;

  /// The sub tree in which [VimiumNode]s can self-register to this [VimiumScopeManager].
  final Widget child;

  final LabelingFactoryBase labelingFactory;

  @override
  State<VimiumScope> createState() => _VimiumScopeState();
}

class _VimiumScopeState<T> extends State<VimiumScope> with VimiumScopeManager {
  @override
  bool get isOverlayShown => widget.isOverlayShown;

  @override
  void initState() {
    super.initState();
    if (widget.isOverlayShown) {
      // need to wait for the child tree to be build at least once.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!widget.isOverlayShown) return;
        assignLabels(widget.labelingFactory);
      });
    }
  }

  @override
  void didUpdateWidget(covariant VimiumScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOverlayShown != oldWidget.isOverlayShown) {
      if (widget.isOverlayShown) {
        assignLabels(widget.labelingFactory);
      } else {
        clearLabels();
      }
    }
  }

  // ---------------------------------------------------------------------------

  final focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------

  void _onKey(KeyEvent keyEvent) async {
    if (!widget.isOverlayShown) return;

    for (final subTree in nodes) {
      if (subTree.handleKeyEvent(keyEvent)) {
        _onMatched();
        break;
      }
    }
  }

  void _onMatched() async {
    widget.onMatched();
    clearLabels();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: VimiumScopeInherited(
        vimiumScopeManager: this,
        child: widget.child,
      ),
    );
  }
}
