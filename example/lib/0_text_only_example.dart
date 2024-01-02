// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:vimium/vimium.dart';

class V0_TextOnlyExample extends StatelessWidget {
  const V0_TextOnlyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: _MyWidget(),
      ),
    );
  }
}

class _MyWidget extends StatefulWidget {
  const _MyWidget({Key? key}) : super(key: key);

  @override
  State<_MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ComponentState<_MyWidget> {
  late final sliderComponent = StateComponentSlider(
    state: this,
    setStateOnChange: true,
    onChange: _onChange,
  );

  void _onChange() {
    currentCount = NumHelper.rescale(
      value: sliderComponent.obj.value,
      min: 0,
      max: 1,
      newMin: 1,
      newMax: maxVal.toDouble(),
    ).round();
    final labelPairs = TwoKeyLabelingFactory().create(Range(currentCount).map((e) => Offset.zero).toList());
    labels = labelPairs.labels.map((e) => "${e.keys.first.keyLabel}${e.keys.second.keyLabel}").toList();
  }

  int currentCount = 0;
  static const maxVal = 80;
  List<String> labels = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("$currentCount"),
          Text(labels.join(" - ")),
          Slider(
            value: sliderComponent.obj.value,
            onChanged: (v) => sliderComponent.obj.value = v,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: labels
                .map(
                  (e) => Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(4),
                    child: Text(e),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
