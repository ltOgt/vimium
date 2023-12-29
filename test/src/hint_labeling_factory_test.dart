import 'package:flutter_test/flutter_test.dart';
import 'package:vimium/src/hint_labeling_factory.dart';

void main() {
  group('HintLabelingFactory', () {
    test("Produces for clustered zero offestes", () {
      final labeling = HintLabelingFactory().create([
        Offset.zero,
        Offset.zero,
        Offset.zero,
        Offset.zero,
        Offset.zero,
      ]);

      expect(
        labeling.labels //
            .map((e) => e.keys)
            .map((e) => "${e.first.keyLabel}${e.second.keyLabel}")
            .toList(),
        ["WF", "CF", "MF", "PF", "GF"],
      );
    });
  });
}
