import 'package:flutter/material.dart';

class FadeInOutTransitionController {
  late void Function({
    int? delay,
    int? duration,
  }) enter;
  late void Function() exit;
}

class FadeInOutTransition extends StatefulWidget {
  const FadeInOutTransition({
    super.key,
    double? begin,
    double? end,
    int? duration,
    bool? enterAtInitial,
    int? delay,
    Curve? curve,
    this.onExit,
    this.controller,
    required this.child,
  })  : enterAtInitial = enterAtInitial ?? true,
        begin = begin ?? 0.0,
        end = end ?? 1.0,
        duration = duration ?? 500,
        delay = delay ?? 0,
        curve = curve ?? Curves.ease;

  final int delay;
  final bool enterAtInitial;
  final Widget child;
  final double begin;
  final double end;
  final int duration;
  final Curve curve;
  final FadeInOutTransitionController? controller;
  final void Function()? onExit;

  @override
  State<FadeInOutTransition> createState() => _FadeInOutTransitionState();
}

class _FadeInOutTransitionState extends State<FadeInOutTransition> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
  late Animation<double> opacity;

  @override
  void initState() {
    opacity = Tween(begin: widget.begin, end: widget.end).animate(CurvedAnimation(parent: controller, curve: widget.curve))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          if (widget.onExit != null) {
            widget.onExit!();
          }
        }
      });
    if (widget.controller != null) {
      widget.controller!.enter = ({
        int? delay,
        int? duration,
      }) {
        controller.duration = Duration(milliseconds: duration ?? widget.duration);
        Future.delayed(Duration(milliseconds: delay ?? widget.delay), controller.forward);
      };
      widget.controller!.exit = () {
        controller.reverse();
      };
    }
    super.initState();

    ///
    if (widget.enterAtInitial) {
      Future.delayed(Duration(milliseconds: widget.delay), controller.forward);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.value,
      child: widget.child,
    );
  }
}
