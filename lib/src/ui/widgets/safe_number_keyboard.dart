import 'package:dua/structure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double useSafeNumberKeyboardHeight(BuildContext context) {
  return MediaQuery.of(context).viewPadding.bottom + 210 + 10;
}

typedef UnSubscribeCallback = void Function([bool? all]);

class _GlobalSafeNumberKeyboardController {
  void Function(bool has) toggleKeyboardDotted = ((has) {});
}

class GlobalSafeNumberKeyboard extends StatefulWidget {
  const GlobalSafeNumberKeyboard({super.key});
  static const String event = "GlobalSafeNumberKeyboard";

  static AnimationController? _animationController;
  static final _GlobalSafeNumberKeyboardController _globalSafeNumberKeyboardController = _GlobalSafeNumberKeyboardController();
  static int duration = 450;

  static void show({bool? hasDot}) {
    if (hasDot == true) {
      _globalSafeNumberKeyboardController.toggleKeyboardDotted(true);
    } else {
      _globalSafeNumberKeyboardController.toggleKeyboardDotted(false);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController?.forward();
    });
  }

  static void hide() {
    _animationController?.reverse();
  }

  static UnSubscribeCallback addKeyPressListener(void Function(String key) callback) {
    return Broadcast.shared.addListener(event, (data) {
      callback(data);
    });
  }

  @override
  State<GlobalSafeNumberKeyboard> createState() => _GlobalSafeNumberKeyboardState();
}

class _GlobalSafeNumberKeyboardState extends State<GlobalSafeNumberKeyboard> with SingleTickerProviderStateMixin {
  late Animation<Offset> position;
  bool hasDot = false;

  void sendKeyEvent(String key) {
    //
    Broadcast.shared.emit(GlobalSafeNumberKeyboard.event, key);
  }

  @override
  void initState() {
    GlobalSafeNumberKeyboard._globalSafeNumberKeyboardController.toggleKeyboardDotted = (has) {
      hasDot = has;
      debugPrint("执行!!! $hasDot");
      setState(() {});
    };
    GlobalSafeNumberKeyboard._animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: GlobalSafeNumberKeyboard.duration),
    );
    position = Tween(begin: const Offset(0, 1.2), end: const Offset(0, 0)).animate(CurvedAnimation(
      parent: GlobalSafeNumberKeyboard._animationController!,
      curve: const ElasticInOutCurve(1.3),
    ))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    GlobalSafeNumberKeyboard._animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: position,
        child: SafeNumberKeyboard(
          hideDot: !hasDot,
          onKeyClicked: sendKeyEvent,
        ),
      ),
    );
  }
}

class SafeNumberKeyboard extends StatefulWidget {
  const SafeNumberKeyboard({
    super.key,
    bool? hideDot,
    this.onKeyClicked,
    double? paddingBottom,
  })  : hideDot = hideDot ?? false,
        paddingBottom = paddingBottom ?? 10;

  final bool hideDot;
  final void Function(String key)? onKeyClicked;
  final double paddingBottom;

  @override
  State<SafeNumberKeyboard> createState() => _SafeNumberKeyboardState();
}

class _SafeNumberKeyboardState extends State<SafeNumberKeyboard> {
  @override
  Widget build(BuildContext context) {
    var safeBottomHeight = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: widget.paddingBottom + safeBottomHeight),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        border: Border(top: BorderSide(width: 1, color: Color(0xFFCCCCCC))),
      ),
      child: SizedBox(
        height: 210,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        build19Box(value: '1'),
                        build19Box(value: '2'),
                        build19Box(value: '3'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        build19Box(value: '4'),
                        build19Box(value: '5'),
                        build19Box(value: '6'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        build19Box(value: '7'),
                        build19Box(value: '8'),
                        build19Box(value: '9'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        build19Box(value: '0'),
                        widget.hideDot ? const SizedBox(width: 0, height: 0) : build19Box(value: '.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  buildBox(key: 'del', child: const Icon(CupertinoIcons.delete_left_fill, size: 18, color: Colors.black)),
                  buildBox(
                    key: 'enter',
                    color: const Color(0xFF528CFF),
                    flex: 3,
                    child: const Text("确定", style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build19Box({String? value, String? key, dynamic onTap}) {
    return buildBox(
      key: key ?? value,
      child: Text(
        value ?? "",
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Widget buildBox({Widget? child, String? key, int flex = 1, Color color = Colors.white}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          child: ClickOpacityBackdropButton(
            color: color,
            onTap: () {
              if (widget.onKeyClicked != null) {
                widget.onKeyClicked!(key!);
              }
            },
            surfaceWidget: UnconstrainedBox(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ClickOpacityBackdropButton extends StatefulWidget {
  const ClickOpacityBackdropButton({
    super.key,
    Color? color,
    this.surfaceWidget,
    this.onTap,
  }) : color = color ?? Colors.white;
  final Color color;
  final Widget? surfaceWidget;
  final void Function()? onTap;

  @override
  State<ClickOpacityBackdropButton> createState() => _ClickOpacityBackdropButtonState();
}

class _ClickOpacityBackdropButtonState extends State<ClickOpacityBackdropButton> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> opacity;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    opacity = Tween(begin: 1.0, end: 0.2).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        animationController.forward();
      },
      onTapUp: (details) {
        animationController.reverse();
      },
      onTapCancel: () {
        animationController.reverse();
      },
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: opacity.value,
              child: Container(color: widget.color),
            ),
            widget.surfaceWidget ?? const SizedBox(width: 0, height: 0),
          ],
        ),
      ),
    );
  }
}
