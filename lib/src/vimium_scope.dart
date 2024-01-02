import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:vimium/vimium.dart';

// =============================================================================
// =============================================================================
// =============================================================================

/// Holds a list of [VimiumNode]s that self-registered to receive [VimiumLabel]s.
mixin VimiumScopeManager {
  bool get isOverlayShown;

  final Set<VimiumNode> _nodes = {};

  /// Register a [VimiumNode] to receive a label
  /// the next time [assignLabels] is called.
  bool register(VimiumNode node) {
    return _nodes.add(node);
  }

  /// Remove the [node] from tracking for [assignLabels].
  bool unRegister(VimiumNode node) {
    return _nodes.remove(node);
  }

  /// assign a unique label to each [VimiumNode] that called [register]
  void assignLabels() {
    final labels = TwoKeyLabelingFactory<VimiumNode>().create(_nodes.toList());
    for (final label in labels) {
      label.data.addLabel(label.joinKeys());
    }
  }

  /// clear the labels for each [VimiumNode] that is still [register]ed
  void clearLabels() {
    for (final node in _nodes) {
      node.clearLabel();
    }
  }
}

// =============================================================================
// =============================================================================
// =============================================================================

/// The root of a sub-tree under which [VimiumNode]s can register to this scope.
class VimiumScope extends StatefulWidget {
  const VimiumScope({
    super.key,
    required this.isOverlayShown,
    required this.onMatched,
    required this.child,
  });

  /// Whether the [VimiumLabel]s for the registered [VimiumNode]s are shown.
  final bool isOverlayShown;

  /// Called when a [VimiumLabel] has been matched for a [VimiumNode].
  final VoidCallback onMatched;

  /// The sub tree in which [VimiumNode]s can self-register to this [VimiumScopeManager].
  final Widget child;

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
        assignLabels();
      });
    }
  }

  @override
  void didUpdateWidget(covariant VimiumScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOverlayShown != oldWidget.isOverlayShown) {
      if (widget.isOverlayShown) {
        assignLabels();
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

    for (final subTree in _nodes) {
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
      child: VimiumScopeInherited._(
        vimiumScopeManager: this,
        child: widget.child,
      ),
    );
  }
}

// =============================================================================
// =============================================================================
// =============================================================================

class VimiumScopeInherited extends InheritedWidget {
  final VimiumScopeManager vimiumScopeManager;

  const VimiumScopeInherited._({
    required this.vimiumScopeManager,
    required super.child,
  });

  static VimiumScopeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VimiumScopeInherited>();
  }

  @override
  bool updateShouldNotify(_) => false;
}

// =============================================================================
// =============================================================================
// =============================================================================

mixin VimiumNode<T extends StatefulWidget> on State<T> {
  VimiumScopeInherited? _scope;

  String? _label;
  void addLabel(String? label) {
    setState(() {
      this._label = label;
    });
  }

  void clearLabel() {
    setState(() {
      this._label = null;
      this.matchedFirst = false;
    });
  }

  bool matchedFirst = false; // TODO limited to exactly two characters for now
  bool handleKeyEvent(KeyEvent value) {
    final char = value.character?.toUpperCase();
    if (_label == null || char == null) return false;
    if (!matchedFirst) {
      setState(() {
        matchedFirst = _label!.startsWith(char);
      });
      return false;
    } else {
      setState(() {
        matchedFirst = false;
      });
      if (_label!.endsWith(char)) {
        onSelected();
        return true;
      }
      return false;
    }
  }

  bool register(VimiumNode self, BuildContext context) {
    _scope = VimiumScopeInherited.of(context);
    if (_scope == null) {
      assert(false, "No VimiumScope found in context");
      return false;
    }

    return _scope!.vimiumScopeManager.register(self);
  }

  bool unRegister(VimiumNode self, BuildContext context) {
    if (_scope == null) return false;

    return _scope!.vimiumScopeManager.unRegister(self);
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    register(this, context);
    super.didChangeDependencies();
  }

  @mustCallSuper
  @override
  void dispose() {
    unRegister(this, context);
    super.dispose();
  }

  Widget buildWrapper(Widget child) => _label == null //
      ? child
      : buildLabelWrap(child, _label!, matchedFirst);

  // =============================================================================

  /// Need to build when [label] is not null
  Widget buildLabelWrap(
    Widget child,
    String label,
    bool isPartialMatch,
  );

  /// Called when the user selected the object via vimium text ovleray
  void onSelected();
}

// =============================================================================
// =============================================================================
// =============================================================================

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
  Widget buildLabelWrap(Widget child, String label, bool isPartialMatch) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Center(
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                color: isPartialMatch ? Colors.blue : Colors.yellow,
                boxShadow: const [BoxShadow()],
              ),
              child: Text(
                label,
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
    final rect = RenderHelper.getRect(globalKey: globalKey);
    if (rect == null) {
      assert(false, "No rect found for context");
      return;
    }

    GestureBinding.instance.handlePointerEvent(PointerDownEvent(
      position: rect.center,
    ));
    GestureBinding.instance.handlePointerEvent(PointerUpEvent(
      position: rect.center,
    ));
  }
}
