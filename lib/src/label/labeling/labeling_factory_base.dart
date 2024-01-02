// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vimium/src/label/labeling/labeling.dart';

abstract class LabelingFactoryBase<T> {
  List<Labeling<T>> create(List<T> data);
}
