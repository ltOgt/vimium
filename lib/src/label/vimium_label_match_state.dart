enum VimiumLabelMatchKind {
  partial,
  full;
}

/// Represents states from non-match over partial-match to fullMatch.
///
/// Using a class on top of the enum to allow for more complex states in sub-classes.
class VimiumLabelMatchState {
  final VimiumLabelMatchKind kind;

  VimiumLabelMatchState({required this.kind});
  VimiumLabelMatchState.partial() : kind = VimiumLabelMatchKind.partial;
  VimiumLabelMatchState.full() : kind = VimiumLabelMatchKind.full;
}
