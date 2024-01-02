import 'package:flutter/material.dart';
import 'package:vimium/src/widget/node/vimium_node.dart';

/// Examplary custom implementation of a clickable component like [ElevatedButton],
///
/// which can be used as a drop in replacement instead of wrapping a regular button
/// manually with [VimiumClickNode].
class VimiumElevatedButton extends StatefulWidget {
  const VimiumElevatedButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    required this.child,
  });

  /// Copied from [ElevatedButton]
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final MaterialStatesController? statesController;
  final Widget? child;

  @override
  State<VimiumElevatedButton> createState() => _VimiumElevatedButtonState();
}

class _VimiumElevatedButtonState extends State<VimiumElevatedButton> with VimiumNode {
  @override
  bool get isEnabled => widget.onPressed != null;

  @override
  void didUpdateWidget(covariant VimiumElevatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.onPressed == null) != (widget.onPressed == null)) {
      onChangedEnabled();
    }
  }

  @override
  void onSelected() {
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      style: widget.style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      statesController: widget.statesController,
      child: widget.child,
    );
  }
}
