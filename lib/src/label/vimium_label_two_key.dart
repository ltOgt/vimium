import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vimium/src/label/vimium_label_base.dart';
import 'package:vimium/src/label/vimium_label_match_state.dart';

/// A [VimiumLabelBase] that is made from a squence of two [LogicalKeyboardKey]s.
///
/// Only regular pressable characters are allowed (A-Z).
class VimiumLabelTwoKeys extends VimiumLabelBase {
  final LogicalKeyboardKey first;
  final LogicalKeyboardKey second;

  @override
  final String value;

  VimiumLabelTwoKeys({
    required this.first,
    required this.second,
  }) : value = "${first.keyLabel}${second.keyLabel}";

  @override
  VimiumLabelMatchState? matchKey(String key, VimiumLabelMatchState? previousState) {
    assert(key.characters.length == 1, "Expected exactly one key, got ${key.length} ($key)");

    return switch (previousState?.kind) {
      null => value.startsWith(key) //
          ? VimiumLabelMatchState.partial()
          : null,
      VimiumLabelMatchKind.partial => value.endsWith(key) //
          ? VimiumLabelMatchState.full()
          : null,
      VimiumLabelMatchKind.full => throw StateError("Don't continue matching after full match"),
    };
  }
}
