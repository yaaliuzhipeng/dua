import 'layout_once_mixin.dart';
import 'package:flutter/widgets.dart';

class OnLayout extends StatefulWidget {
  const OnLayout({
    super.key,
    required this.onLayout,
    required this.child,
  });

  final Widget child;
  final void Function(RenderBox box) onLayout;

  @override
  State<OnLayout> createState() => _OnLayoutState();
}

class _OnLayoutState extends State<OnLayout> with LayoutOnceMixin {
  Size previousSize = Size.zero;

  @override
  onBuildLayoutFrameCallbackPosted(RenderBox box, BuildContext context) {
    widget.onLayout(box);
  }

  @override
  Widget build(BuildContext context) {
    postLayoutMeasureResult(context);
    return widget.child;
  }
}
