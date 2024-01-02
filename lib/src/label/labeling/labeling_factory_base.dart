// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vimium/src/label/labeling/labeling.dart';
import 'package:vimium/src/label/vimium_label_base.dart';

/// Base for a factory that [create]s a list of [Labeling]s for some [data].
abstract class LabelingFactoryBase<L extends VimiumLabelBase> {
  List<Labeling<D, L>> create<D>(List<D> data);
}
