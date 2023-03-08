import 'package:flutter/widgets.dart';

typedef OnSizeChanged = void Function(Size size);

class OnClippedLayout extends StatefulWidget {
  const OnClippedLayout({
    super.key,
    required this.child,
    this.onSizeChanged,
  });

  final Widget child;
  final OnSizeChanged? onSizeChanged;

  @override
  State<OnClippedLayout> createState() => _OnClippedLayoutState();
}

class _OnClippedLayoutState extends State<OnClippedLayout> {
  Size size = Size.zero;

  void onSizeChanged(Size v) {
    size = v;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (size.width != v.width && size.height != v.height) {
        if (widget.onSizeChanged != null) {
          widget.onSizeChanged!(v);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: CustomMultiChildLayout(
          delegate: LayoutDelegate(onSizeChanged: onSizeChanged, currentSize: size),
          children: [
            LayoutId(id: 1, child: SizedBox(child: widget.child)),
          ],
        ),
      ),
    );
  }
}

class LayoutDelegate extends MultiChildLayoutDelegate {
  LayoutDelegate({required this.onSizeChanged, required this.currentSize});

  final OnSizeChanged onSizeChanged;
  final Size currentSize;

  @override
  void performLayout(Size size) {
    if (hasChild(1)) {
      final firstSize = layoutChild(1, const BoxConstraints());
      if (currentSize != firstSize) {
        onSizeChanged(firstSize);
      }
    }
  }

  /// always relayout children when system required
  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
