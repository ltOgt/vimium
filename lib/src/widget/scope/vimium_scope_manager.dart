import 'dart:collection';

import 'package:vimium/src/label/labeling/labeling_factory_base.dart';
import 'package:vimium/src/label/vimium_label_base.dart';
import 'package:vimium/src/widget/node/vimium_node.dart';

/// Holds a list of [VimiumNode]s that self-registered to receive [VimiumLabel]s.
mixin VimiumScopeManager {
  bool get isOverlayShown;

  final Set<VimiumNode> _nodes = {};
  Set<VimiumNode> get nodes => UnmodifiableSetView(_nodes);

  /// Register a [VimiumNode] to receive a label
  /// the next time [assignLabels] is called.
  bool register(VimiumNode node) {
    return _nodes.add(node);
  }

  /// Remove the [node] from tracking for [assignLabels].
  bool unRegister(VimiumNode node) {
    return _nodes.remove(node);
  }

  /// assign a unique label to each [VimiumNode] that called [register]
  void assignLabels<L extends VimiumLabelBase>(LabelingFactoryBase<L> labelingFactory) {
    final labelings = labelingFactory.create(_nodes.toList());
    for (final labeling in labelings) {
      labeling.data.addLabel(labeling.label);
    }
  }

  /// clear the labels for each [VimiumNode] that is still [register]ed
  void clearLabels() {
    for (final node in _nodes) {
      node.clearLabel();
    }
  }
}
