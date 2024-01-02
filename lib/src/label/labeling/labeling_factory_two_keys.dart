import 'package:flutter/services.dart';
import 'package:vimium/src/label/labeling/labeling.dart';
import 'package:vimium/src/label/labeling/labeling_factory_base.dart';
import 'package:vimium/src/label/vimium_label_two_key.dart';

class LabelingFactoryTwoKeys<T> implements LabelingFactoryBase<T> {
  /// Note: currently can only cover data with length up to 122
  @override
  List<Labeling<T>> create(List<T> data) {
    assert(data.length <= _coveredLength());

    final generator = _generatorLeftBucket().iterator;
    VimiumLabelTwoKeys getAndNext() {
      generator.moveNext();
      return generator.current;
    }

    return [
      for (final d in data) //
        Labeling(
          data: d,
          label: getAndNext(),
        ),
    ];
  }
}

Iterable<VimiumLabelTwoKeys> _generatorLeftBucket() sync* {
  for (final left in _left) {
    for (final bucket in _bucket) {
      yield VimiumLabelTwoKeys(first: bucket, second: left);
    }
  }
  for (final right in _right) {
    for (final bucket in _bucket) {
      yield VimiumLabelTwoKeys(first: bucket, second: right);
    }
  }
  for (final overflow in _overflow) {
    for (final bucket in _bucket) {
      yield VimiumLabelTwoKeys(first: bucket, second: overflow);
    }
  }
  for (final bucket1 in _bucket) {
    for (final bucket in _bucket) {
      yield VimiumLabelTwoKeys(first: bucket, second: bucket1);
    }
  }
  for (final left in _left) {
    for (final right in _right) {
      yield VimiumLabelTwoKeys(first: right, second: left);
    }
  }
  for (final right in _right) {
    for (final left in _left) {
      yield VimiumLabelTwoKeys(first: left, second: right);
    }
  }
  // while (true) {
  //   yield null; // TODO explictly yield null here and handle
  // }
}

int _coveredLength() => (_left.length * _bucket.length +
    _right.length * _bucket.length +
    _overflow.length * _bucket.length +
    _bucket.length * _bucket.length +
    _left.length * _right.length +
    _right.length * _left.length);

// key buckets based on https://github.com/philc/vimium
// though not exactly the same

final Set<LogicalKeyboardKey> _left = {
  /// asdf, mixed
  LogicalKeyboardKey.keyA,
  LogicalKeyboardKey.keyD,
  LogicalKeyboardKey.keyF,
  LogicalKeyboardKey.keyS,
};

final Set<LogicalKeyboardKey> _right = {
  /// hjkl, mixed
  LogicalKeyboardKey.keyJ,
  LogicalKeyboardKey.keyH,
  LogicalKeyboardKey.keyL,
  LogicalKeyboardKey.keyK,
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
