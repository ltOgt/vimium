import 'package:flutter/material.dart';
import 'package:vimium/src/widget/node/vimium_node.dart';

/// A [StatefulWidget] that implements [VimiumNode] resulting in a
/// focus request for the nearest ancestor [FocusNode].
class VimiumFocusNode extends StatefulWidget {
  const VimiumFocusNode({
    super.key,
    this.isEnabled = true,
    required this.child,
  });

  final bool isEnabled;
  final Widget child;

  @override
  State<VimiumFocusNode> createState() => _VimiumFocusNodeState();
}

class _VimiumFocusNodeState extends State<VimiumFocusNode> with VimiumNode {
  @override
  bool get isEnabled => widget.isEnabled;
  @override
  void didUpdateWidget(covariant VimiumFocusNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled != widget.isEnabled) {
      onChangedEnabled();
    }
  }

  @override
  Widget build(BuildContext context) => buildWrapper(widget.child);

  @override
  void onSelected() {
    Focus.maybeOf(context, createDependency: false)?.requestFocus();
  }
}
