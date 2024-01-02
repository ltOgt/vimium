import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vimium/src/widget/node/vimium_node.dart';

/// A [StatefulWidget] that implements [VimiumNode] resulting in a
/// simulated tap on the center of its [RenderBox] on a match.
class VimiumClickNode extends StatefulWidget {
  const VimiumClickNode({
    super.key,
    this.isEnabled = true,
    required this.child,
  });

  final bool isEnabled;
  final Widget child;

  @override
  State<VimiumClickNode> createState() => _VimiumClickNodeState();
}

class _VimiumClickNodeState extends State<VimiumClickNode> with VimiumNode {
  final globalKey = GlobalKey();

  @override
  bool get isEnabled => widget.isEnabled;
  @override
  void didUpdateWidget(covariant VimiumClickNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled != widget.isEnabled) {
      onChangedEnabled();
    }
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
        key: globalKey,
        child: buildWrapper(widget.child),
      );

  @override
  void onSelected() {
    final renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      assert(false, "No rect found for context");
      return;
    }

    final rect = renderObject.localToGlobal(Offset.zero) & renderObject.size;

    GestureBinding.instance.handlePointerEvent(PointerDownEvent(
      position: rect.center,
    ));
    GestureBinding.instance.handlePointerEvent(PointerUpEvent(
      position: rect.center,
    ));
  }
}
