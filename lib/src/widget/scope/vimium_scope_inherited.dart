import 'package:flutter/widgets.dart';
import 'package:vimium/src/widget/scope/vimium_scope_manager.dart';

/// Used to look up ancestor [vimiumScopeManager] in `O(1)` with
/// [BuildContext.dependOnInheritedWidgetOfExactType].
///
/// [updateShouldNotify] is not used.
class VimiumScopeInherited extends InheritedWidget {
  final VimiumScopeManager vimiumScopeManager;

  const VimiumScopeInherited({
    super.key,
    required this.vimiumScopeManager,
    required super.child,
  });

  static VimiumScopeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VimiumScopeInherited>();
  }

  @override
  bool updateShouldNotify(oldWidget) => false;
}
