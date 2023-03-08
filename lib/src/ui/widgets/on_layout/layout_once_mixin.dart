import 'package:flutter/widgets.dart';

mixin LayoutOnceMixin {
  Size previousMeasuredSize = Size.zero;

  /// [override_this]
  void onBuildLayoutFrameCallbackPosted(RenderBox box, BuildContext context);

  void postLayoutMeasureResult(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var object = context.findRenderObject();
      if (object != null) {
        var box = object as RenderBox;
        if (box.size != previousMeasuredSize) {
          previousMeasuredSize = box.size;
          onBuildLayoutFrameCallbackPosted(box, context);
        }
      }
    });
  }

}
