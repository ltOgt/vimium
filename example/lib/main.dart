import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vimium/vimium.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  void resetOnScroll() {
    if (isOverlayShown) {
      setState(() {
        isOverlayShown = false;
      });
    }
  }

  final scrollController = ScrollController();

  bool handleKeyEvent(KeyEvent e) {
    if (HardwareKeyboard.instance.isMetaPressed && e.character?.toUpperCase() == "F") {
      setState(() {
        isOverlayShown = !isOverlayShown;
      });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(handleKeyEvent);
    scrollController.addListener(resetOnScroll);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(handleKeyEvent);
    scrollController.removeListener(resetOnScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          isOverlayShown = !isOverlayShown;
        }),
        child: const Text("META + F"),
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
                child: Column(
                  children: [
                    const Text("Content"),
                    VimiumClickNode(
                      child: FloatingActionButton(
                        onPressed: () => scrollController.animateTo(
                          scrollController.offset - 400,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceIn,
                        ),
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      width: 400,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 1000,
                        itemBuilder: (context, index) => Row(
                          children: [
                            _ClickableReset("Row $index - Action 1"),
                            _ClickableReset("Row $index - Action 2"),
                          ],
                        ),
                      ),
                    ),
                    VimiumClickNode(
                      child: FloatingActionButton(
                        onPressed: () => scrollController.animateTo(
                          scrollController.offset + 400,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceIn,
                        ),
                        child: const Icon(Icons.arrow_downward),
                      ),
                    ),
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
