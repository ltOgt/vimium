// ignore_for_file: file_names, camel_case_types

import 'package:example/vimium_scope.dart';
import 'package:flutter/material.dart';

class V2_InheritedWidgetScopeApp extends StatelessWidget {
  const V2_InheritedWidgetScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isOverlayShown = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          isOverlayShown = !isOverlayShown;
        }),
        child: isOverlayShown ? const Icon(Icons.highlight) : const Icon(Icons.highlight_outlined),
      ),
      body: VimiumScope(
        isOverlayShown: isOverlayShown,
        onMatched: () => setState(() {
          isOverlayShown = false;
        }),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Column(
                  children: [
                    Text("SideBar"),
                    Spacer(),
                    _ClickableReset("Option 1"),
                    _ClickableReset("Option 2"),
                    _ClickableReset("Option 3"),
                    _ClickableReset("Option 4"),
                    _ClickableReset("Option 5"),
                    _ClickableReset("Option 5"),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Column(
                  children: [
                    Text("Content"),
                    Spacer(),
                    Row(
                      children: [
                        _ClickableReset("Row 1 - Action 1"),
                        _ClickableReset("Row 1 - Action 2"),
                      ],
                    ),
                    Row(
                      children: [
                        _ClickableReset("Row 2 - Action 1"),
                        _ClickableReset("Row 2 - Action 2"),
                      ],
                    ),
                    Row(
                      children: [
                        _ClickableReset("Row 3 - Action 1"),
                        _ClickableReset("Row 3 - Action 2"),
                      ],
                    ),
                    Row(
                      children: [
                        _ClickableReset("Row 4 - Action 1"),
                        _ClickableReset("Row 4 - Action 2"),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClickableReset extends StatefulWidget {
  const _ClickableReset(this.text);

  final String text;

  @override
  State<_ClickableReset> createState() => __ClickableResetState();
}

class __ClickableResetState extends State<_ClickableReset> {
  bool isPressed = false;
  void press() async {
    setState(() {
      isPressed = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VimiumClickNode(
      // NOTE: explicitly not wired up to `press`, you can put this further up in the tree
      child: Container(
        margin: const EdgeInsets.all(8.123),
        color: isPressed ? Colors.black : Colors.grey,
        child: TextButton(
          onPressed: press,
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
