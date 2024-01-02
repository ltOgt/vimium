// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:vimium/vimium.dart';

class V1_FirstTestToPlugAndPlay extends StatefulWidget {
  const V1_FirstTestToPlugAndPlay({super.key});

  @override
  State<V1_FirstTestToPlugAndPlay> createState() => _V1_FirstTestToPlugAndPlayState();
}

class _V1_FirstTestToPlugAndPlayState extends ComponentState<V1_FirstTestToPlugAndPlay> {
  late final componentFocus = StateComponentFocus(state: this);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: KeyboardListener(
          autofocus: true,
          focusNode: componentFocus.obj,
          onKeyEvent: VimiumManager.instance.onKeyEvent,
          child: const MyWidget(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            VimiumManager.instance.toggle();
            setState(() {});
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
          Colors.grey,
          Colors.green,
        ]),
        width: RandomUtils().randomFrom([100, 150, 200]),
        height: RandomUtils().randomFrom([100, 150, 300]),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Center(child: child),
      );

  @override
  Widget build(BuildContext context) {
    //return Center(child: contain(VimiumContainer(action: () {}, child: Text("Moin"))));
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
  bool get isShown => _showing;

  void toggle() {
    if (_showing) {
      _showing = false;
      for (var e in _containers) {
        e.hideHint();
      }
    } else {
      _showing = true;

      for (var e in TwoKeyLabelingFactory<_VimiumContainerState>().create(_containers.toList()).labels) {
        e.data.showHint(e.joinKeys());
      }
    }
  }

  void onKeyEvent(KeyEvent value) {
    if (!isShown) return;
    print("keyEvent: ${value.character}");
    for (final container in _containers) {
      container.processKeyEvent(value);
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

  bool matchedFirst = false;
  void processKeyEvent(KeyEvent value) {
    final char = value.character?.toUpperCase();
    if (hint == null || char == null) return;
    if (!matchedFirst) {
      setState(() {
        matchedFirst = hint!.startsWith(char);
      });
    } else {
      setState(() {
        matchedFirst = false;
      });
      if (hint!.endsWith(char)) {
        print("was matched");

        wasMatched();
      }
    }
  }

  void wasMatched() {
    triggerAction();
    highlight();
    // VimiumManager.instance.toggle();
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

  bool isHighlighted = false;
  void highlight() async {
    if (isHighlighted) return;
    setState(() {
      isHighlighted = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isHighlighted = false;
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
            color: isHighlighted
                ? Colors.pink
                : matchedFirst
                    ? Colors.lightBlueAccent
                    : Colors.orange,
            padding: const EdgeInsets.all(8),
            child: Text(hint!),
          ),
        ),
      ],
    );
  }
}
