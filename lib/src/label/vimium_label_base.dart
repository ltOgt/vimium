import 'package:vimium/src/label/vimium_label_match_state.dart';

/// A label assigned to a [VimiumNode], to make it "clickable" via keyboard
abstract class VimiumLabelBase {
  /// The value shown to the user,
  /// representing what needs to be typed to match this label.
  String get value;

  /// Checks the user-pressed [key] against the [previousState]
  /// to emit a new [VimiumLabelMatchState]
  VimiumLabelMatchState matchKey(String key, VimiumLabelMatchState previousState);
}
