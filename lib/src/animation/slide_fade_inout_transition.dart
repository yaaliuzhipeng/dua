import 'package:flutter/material.dart';

class SlideFadeInOutTransitionController {
  late void Function({int? delay, int? duration}) enter;
  late void Function() exit;
}

class SlideFadeInOutTransition extends StatefulWidget {
  const SlideFadeInOutTransition({
    super.key,
    Offset? begin,
    Offset? end,
    int? duration,
    bool? enterAtInitial,
    int? delay,
    bool? opacityEnabled,
    Curve? opacityCurve,
    this.onExit,
    this.controller,
    required this.child,
  })  : enterAtInitial = enterAtInitial ?? true,
        begin = begin ?? const Offset(0, 1),
        end = end ?? const Offset(0, 0),
        duration = duration ?? 500,
        delay = delay ?? 0,
        opacityEnabled = opacityEnabled ?? true,
        opacityCurve = opacityCurve ?? const Cubic(.77, .01, .26, 1);

  final bool opacityEnabled;
  final int delay;
  final bool enterAtInitial;
  final Widget child;
  final Offset begin;
  final Offset end;
  final int duration;
  final Curve opacityCurve;
  final SlideFadeInOutTransitionController? controller;
  final void Function()? onExit;

  @override
  State<SlideFadeInOutTransition> createState() => _SlideFadeInOutTransitionState();
}

class _SlideFadeInOutTransitionState extends State<SlideFadeInOutTransition> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
  late Animation<double> opacity;
  late Animation<Offset> offset;

  @override
  void initState() {
    opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: widget.opacityCurve));
    offset = Tween(begin: widget.begin, end: widget.end).animate(CurvedAnimation(parent: controller, curve: Curves.decelerate))
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
      widget.controller!.enter = ({int? delay, int? duration}) {
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
      opacity: widget.opacityEnabled ? opacity.value : 1.0,
      child: SlideTransition(
        position: offset,
        child: widget.child,
      ),
    );
  }
}
