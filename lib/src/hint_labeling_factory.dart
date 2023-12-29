// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';

class HintLabeling<T> {
  final List<HintLabel<T>> labels;

  HintLabeling({required this.labels});
}

class HintLabel<T> {
  final T data;
  final LABEL keys;

  HintLabel({
    required this.data,
    required this.keys,
  });

  String joinKeys() => "${keys.first.keyLabel}${keys.second.keyLabel}";
}

abstract class HintLabelingFactoryBase<T> {
  HintLabeling<T> create(List<T> data);
}

typedef LABEL = ({LogicalKeyboardKey first, LogicalKeyboardKey second});

class HintLabelingFactory<T> implements HintLabelingFactoryBase<T> {
  @override
  HintLabeling<T> create(List<T> data) {
    final generator = _generatorLeftBucket().iterator;
    LABEL getAndNext() {
      generator.moveNext();
      return generator.current;
    }

    final labels = [
      for (final d in data) //
        HintLabel(data: d, keys: getAndNext()),
    ];

    return HintLabeling(labels: labels);
  }
}

Iterable<({LogicalKeyboardKey first, LogicalKeyboardKey second})> _generatorLeftBucket() sync* {
  for (final left in _left) {
    for (final bucket in _bucket) {
      yield (first: bucket, second: left);
    }
  }
  for (final right in _right) {
    for (final bucket in _bucket) {
      yield (first: bucket, second: right);
    }
  }
  for (final overflow in _overflow) {
    for (final bucket in _bucket) {
      yield (first: bucket, second: overflow);
    }
  }
  for (final bucket1 in _bucket) {
    for (final bucket in _bucket) {
      yield (first: bucket, second: bucket1);
    }
  }
}

// only use left with bucket for now, make adjustable later

final Set<LogicalKeyboardKey> _left = {
  /// asdf, mixed
  LogicalKeyboardKey.keyA,
  LogicalKeyboardKey.keyD,
  LogicalKeyboardKey.keyF,
  LogicalKeyboardKey.keyS,
  // LogicalKeyboardKey.keyF,
  // LogicalKeyboardKey.keyS,
  // LogicalKeyboardKey.keyD,
  // LogicalKeyboardKey.keyA,
};

final Set<LogicalKeyboardKey> _right = {
  /// hjkl, mixed
  LogicalKeyboardKey.keyJ,
  LogicalKeyboardKey.keyH,
  LogicalKeyboardKey.keyL,
  LogicalKeyboardKey.keyK,
  // LogicalKeyboardKey.keyH,
  // LogicalKeyboardKey.keyK,
  // LogicalKeyboardKey.keyJ,
  // LogicalKeyboardKey.keyL,
};

final Set<LogicalKeyboardKey> _bucket = {
  /// WCMPG, circle outside
  LogicalKeyboardKey.keyW,
  LogicalKeyboardKey.keyC,
  LogicalKeyboardKey.keyM,
  LogicalKeyboardKey.keyP,
  LogicalKeyboardKey.keyG,
};

final Set<LogicalKeyboardKey> _overflow = {
  /// ERUIO, mixed
  LogicalKeyboardKey.keyE,
  LogicalKeyboardKey.keyU,
  LogicalKeyboardKey.keyR,
  LogicalKeyboardKey.keyO,
  LogicalKeyboardKey.keyI,
};


// const Set<LogicalKeyboardKey> _gValidKeys = {
//   // Left Main Row
//   ,
//   LogicalKeyboardKey.keyS,
//   LogicalKeyboardKey.keyD,
//   LogicalKeyboardKey.keyF,
//   LogicalKeyboardKey.keyG,
//   // Right Main Row
//   LogicalKeyboardKey.keyH,
//   LogicalKeyboardKey.keyJ,
//   LogicalKeyboardKey.keyK,
//   LogicalKeyboardKey.keyL,
//   // TODO can add more in the future
// };
