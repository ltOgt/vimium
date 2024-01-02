import 'package:flutter_test/flutter_test.dart';
import 'package:vimium/src/label/labeling/labeling_factory_two_keys.dart';

void main() {
  group('HintLabelingFactory', () {
    test("Produces for clustered zero offestes", () {
      final labels = LabelingFactoryTwoKeys().create([
        Offset.zero,
        Offset.zero,
        Offset.zero,
        Offset.zero,
        Offset.zero,
      ]);

      expect(
        labels //
            .map((e) => e.label.value)
            .toList(),
        ["WA", "CA", "MA", "PA", "GA"],
      );
    });
  });
}
