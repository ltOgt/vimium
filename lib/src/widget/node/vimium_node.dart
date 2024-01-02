import 'package:flutter/widgets.dart';
import 'package:vimium/src/label/vimium_label_base.dart';
import 'package:vimium/src/label/vimium_label_match_state.dart';
import 'package:vimium/src/widget/scope/vimium_scope_inherited.dart';

mixin VimiumNode<T extends StatefulWidget> on State<T> {
  VimiumScopeInherited? _scope;

  VimiumLabelMatchState? _matchState;
  VimiumLabelMatchState? get matchState => _matchState;

  VimiumLabelBase? _label;
  void addLabel(VimiumLabelBase label) {
    setState(() {
      this._label = label;
    });
  }

  void clearLabel() {
    setState(() {
      this._label = null;
      this._matchState = null;
    });
  }

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
      : buildLabelWrap(child, _label!.value, _matchState);

  // =============================================================================

  /// Need to build when [label] is not null
  Widget buildLabelWrap(
    Widget child,
    String labelValue,
    VimiumLabelMatchState? matchState,
  );

  /// Called when the user selected the object via vimium text ovleray
  void onSelected();
}
