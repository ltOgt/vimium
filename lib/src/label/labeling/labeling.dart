// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:vimium/src/label/vimium_label_base.dart';

class Labeling<T> {
  final T data;
  final VimiumLabelBase label;

  Labeling({
    required this.data,
    required this.label,
  });
}
