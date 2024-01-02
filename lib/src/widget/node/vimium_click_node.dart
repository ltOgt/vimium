import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vimium/src/label/vimium_label_match_state.dart';
import 'package:vimium/src/widget/node/vimium_node.dart';

/// A [StatefulWidget] that implements [VimiumNode] resulting in a
/// simulated tap on the center of its [RenderBox] on a match.
class VimiumClickNode extends StatefulWidget {
  const VimiumClickNode({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<VimiumClickNode> createState() => _VimiumClickNodeState();
}

class _VimiumClickNodeState extends State<VimiumClickNode> with VimiumNode {
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
        key: globalKey,
        child: buildWrapper(widget.child),
      );

  @override
  Widget buildLabelWrap(Widget child, String labelValue, VimiumLabelMatchState? matchState) {
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
