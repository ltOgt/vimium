// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:vimium/vimium.dart';

class V1_FirstTestToPlugAndPlay extends StatelessWidget {
  const V1_FirstTestToPlugAndPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MyWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            VimiumManager.instance.toggle();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  Widget contain(Widget child) => Container(
        color: RandomUtils().randomFrom([
          Colors.red,
          Colors.blue,
          Colors.white,
          Colors.white,
        ]),
        width: RandomUtils().randomFrom([100, 150, 200]),
        height: RandomUtils().randomFrom([100, 150, 300]),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Center(child: child),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        contain(
          Row(
            children: [
              contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
              contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
              contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
              contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
            ],
          ),
        ),
        contain(
          Row(
            children: [
              contain(VimiumContainer(action: () => print("action 3"), child: Text("3"))),
              contain(VimiumContainer(action: () => print("action 4"), child: Text("4"))),
              Column(
                children: [
                  contain(
                    Row(
                      children: [
                        contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
                        contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
                        Column(
                          children: [
                            contain(
                              Row(
                                children: [
                                  contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
                                  contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
                                  contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
                                  contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
                                ],
                              ),
                            ),
                            contain(
                              Row(
                                children: [
                                  contain(VimiumContainer(action: () => print("action 3"), child: Text("3"))),
                                  contain(VimiumContainer(action: () => print("action 4"), child: Text("4"))),
                                  Column(
                                    children: [
                                      contain(
                                        Row(
                                          children: [
                                            contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
                                            contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
                                            contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
                                            Column(
                                              children: [
                                                contain(
                                                  Row(
                                                    children: [
                                                      contain(VimiumContainer(
                                                          action: () => print("action 1"), child: Text("1"))),
                                                      contain(VimiumContainer(
                                                          action: () => print("action 2"), child: Text("2"))),
                                                      contain(VimiumContainer(
                                                          action: () => print("action 1"), child: Text("1"))),
                                                      contain(VimiumContainer(
                                                          action: () => print("action 2"), child: Text("2"))),
                                                    ],
                                                  ),
                                                ),
                                                contain(
                                                  Row(
                                                    children: [
                                                      contain(VimiumContainer(
                                                          action: () => print("action 3"), child: Text("3"))),
                                                      contain(VimiumContainer(
                                                          action: () => print("action 4"), child: Text("4"))),
                                                      Column(
                                                        children: [
                                                          contain(
                                                            Row(
                                                              children: [
                                                                contain(VimiumContainer(
                                                                    action: () => print("action 1"), child: Text("1"))),
                                                                contain(VimiumContainer(
                                                                    action: () => print("action 2"), child: Text("2"))),
                                                                Column(
                                                                  children: [
                                                                    contain(
                                                                      Row(
                                                                        children: [
                                                                          contain(VimiumContainer(
                                                                              action: () => print("action 1"),
                                                                              child: Text("1"))),
                                                                          contain(VimiumContainer(
                                                                              action: () => print("action 2"),
                                                                              child: Text("2"))),
                                                                          contain(VimiumContainer(
                                                                              action: () => print("action 1"),
                                                                              child: Text("1"))),
                                                                          contain(VimiumContainer(
                                                                              action: () => print("action 2"),
                                                                              child: Text("2"))),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    contain(
                                                                      Row(
                                                                        children: [
                                                                          contain(VimiumContainer(
                                                                              action: () => print("action 3"),
                                                                              child: Text("3"))),
                                                                          contain(VimiumContainer(
                                                                              action: () => print("action 4"),
                                                                              child: Text("4"))),
                                                                          Column(
                                                                            children: [
                                                                              contain(
                                                                                Row(
                                                                                  children: [
                                                                                    contain(VimiumContainer(
                                                                                        action: () => print("action 1"),
                                                                                        child: Text("1"))),
                                                                                    contain(VimiumContainer(
                                                                                        action: () => print("action 2"),
                                                                                        child: Text("2"))),
                                                                                    contain(VimiumContainer(
                                                                                        action: () => print("action 1"),
                                                                                        child: Text("1"))),
                                                                                    contain(VimiumContainer(
                                                                                        action: () => print("action 2"),
                                                                                        child: Text("2"))),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              contain(
                                                                                Row(
                                                                                  children: [
                                                                                    contain(VimiumContainer(
                                                                                        action: () => print("action 3"),
                                                                                        child: Text("3"))),
                                                                                    contain(VimiumContainer(
                                                                                        action: () => print("action 4"),
                                                                                        child: Text("4"))),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                contain(VimiumContainer(
                                                                    action: () => print("action 1"), child: Text("1"))),
                                                                contain(VimiumContainer(
                                                                    action: () => print("action 2"), child: Text("2"))),
                                                              ],
                                                            ),
                                                          ),
                                                          contain(
                                                            Row(
                                                              children: [
                                                                contain(VimiumContainer(
                                                                    action: () => print("action 3"), child: Text("3"))),
                                                                contain(VimiumContainer(
                                                                    action: () => print("action 4"), child: Text("4"))),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
                                          ],
                                        ),
                                      ),
                                      contain(
                                        Row(
                                          children: [
                                            contain(VimiumContainer(action: () => print("action 3"), child: Text("3"))),
                                            contain(VimiumContainer(action: () => print("action 4"), child: Text("4"))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        contain(VimiumContainer(action: () => print("action 1"), child: Text("1"))),
                        contain(VimiumContainer(action: () => print("action 2"), child: Text("2"))),
                      ],
                    ),
                  ),
                  contain(
                    Row(
                      children: [
                        contain(VimiumContainer(action: () => print("action 3"), child: Text("3"))),
                        contain(VimiumContainer(action: () => print("action 4"), child: Text("4"))),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

///
///
///
///
///
//////
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///

/// Doiing it dirty for first draft
class VimiumManager {
  VimiumManager._();
  static final instance = VimiumManager._();

  final Set<_VimiumContainerState> _containers = {};

  void _register(_VimiumContainerState state) => _containers.add(state);
  void _unRegister(_VimiumContainerState state) => _containers.remove(state);

  bool _showing = false;

  void toggle() {
    if (_showing) {
      _showing = false;
      for (var e in _containers) {
        e.hideHint();
      }
    } else {
      _showing = true;

      for (var e in HintLabelingFactory<_VimiumContainerState>().create(_containers.toList()).labels) {
        e.data.showHint(e.joinKeys());
      }
    }
  }
}

///
///
///
///
///
class VimiumContainer extends StatefulWidget {
  const VimiumContainer({
    super.key,
    required this.action,
    required this.child,
  });

  final VoidCallback action;
  final Widget child;

  @override
  State<VimiumContainer> createState() => _VimiumContainerState();
}

class _VimiumContainerState extends State<VimiumContainer> {
  @override
  void initState() {
    super.initState();
    VimiumManager.instance._register(this);
  }

  String? hint;
  void showHint(String hint) {
    setState(() {
      this.hint = hint;
    });
  }

  void triggerAction() {
    widget.action();
  }

  void hideHint() {
    setState(() {
      hint = null;
    });
  }

  @override
  void dispose() {
    VimiumManager.instance._unRegister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hint == null) return widget.child;

    return Stack(
      children: [
        Positioned.fill(
          child: widget.child,
        ),
        Center(
          child: Container(
            color: Colors.orange,
            padding: const EdgeInsets.all(8),
            child: Text(hint!),
          ),
        ),
      ],
    );
  }
}
