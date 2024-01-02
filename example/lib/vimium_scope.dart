import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:vimium/vimium.dart';

// =============================================================================
// =============================================================================
// =============================================================================

class VimiumScope extends StatefulWidget {
  const VimiumScope({
    super.key,
    required this.isOverlayShown,
    required this.onMatched,
    required this.child,
  });

  final bool isOverlayShown;
  final VoidCallback onMatched;
  final Widget child;

  @override
  State<VimiumScope> createState() => _VimiumScopeState();
}

class _VimiumScopeState<T> extends State<VimiumScope> {
  final Set<VimiumSubTree> _subTrees = {};

  /// does not automatically update on [_subTrees] change.
  /// only called when show or no show changes
  void _createKeyMapping() {
    final labeling = HintLabelingFactory<VimiumSubTree>().create(_subTrees.toList());
    for (final label in labeling.labels) {
      label.data.addLabel(label.joinKeys());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isOverlayShown) {
      // need to wait for the child tree to be build
      RenderHelper.nextFrameFuture.then(
        (_) {
          if (!widget.isOverlayShown) return;
          _createKeyMapping();
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant VimiumScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOverlayShown != oldWidget.isOverlayShown) {
      if (widget.isOverlayShown) {
        _createKeyMapping();
      } else {
        for (final subTree in _subTrees) {
          subTree.clearLabel();
        }
      }
    }
  }

  void _onMatched() async {
    widget.onMatched();
    for (final subTree in _subTrees) {
      subTree.clearLabel();
    }
  }

  final focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (keyEvent) async {
        if (!widget.isOverlayShown) return;

        for (final subTree in _subTrees) {
          if (subTree.handleKeyEvent(keyEvent)) {
            _onMatched();
            break;
          }
        }
      },
      child: _VimiumScopeInherited._(
        subTrees: _subTrees,
        isOverlayShown: widget.isOverlayShown,
        child: widget.child,
      ),
    );
  }
}

// =============================================================================
// =============================================================================
// =============================================================================

class _VimiumScopeInherited extends InheritedWidget {
  final Set<VimiumSubTree> _subTrees;
  final bool isOverlayShown;

  const _VimiumScopeInherited._({
    required Set<VimiumSubTree> subTrees,
    required this.isOverlayShown,
    required super.child,
  }) : _subTrees = subTrees;

  static _VimiumScopeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_VimiumScopeInherited>();
  }

  bool register(VimiumSubTree subTree) {
    return _subTrees.add(subTree);
  }

  bool unRegister(VimiumSubTree subTree) {
    return _subTrees.remove(subTree);
  }

  @override
  bool updateShouldNotify(
          covariant _VimiumScopeInherited
              oldWidget) => // // TODO maybe can just be false since state calls listeners anyways
      oldWidget.isOverlayShown != isOverlayShown;
}

// =============================================================================
// =============================================================================
// =============================================================================

mixin VimiumSubTree<T extends StatefulWidget> on State<T> {
  _VimiumScopeInherited? _scope;

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

  bool register(VimiumSubTree self, BuildContext context) {
    _scope = _VimiumScopeInherited.of(context);
    if (_scope == null) {
      assert(false, "No VimiumScope found in context");
      return false;
    }

    return _scope!.register(self);
  }

  bool unRegister(VimiumSubTree self, BuildContext context) {
    if (_scope == null) return false;

    return _scope!.unRegister(self);
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

class _VimiumClickNodeState extends State<VimiumClickNode> with VimiumSubTree {
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
