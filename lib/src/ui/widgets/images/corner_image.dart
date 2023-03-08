import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CornerImage extends StatelessWidget {
  const CornerImage(
    this.src, {
    super.key,
    required this.size,
    this.defaultSrc,
    this.defaultImage,
    this.boxShadow,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? radius,
    bool? useCachedNetworkImage,
    BoxFit? fit,
  })  : borderColor = borderColor ?? Colors.transparent,
        backgroundColor = backgroundColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0,
        borderRadius = radius ?? BorderRadius.zero,
        useCachedNetworkImage = useCachedNetworkImage ?? true,
        fit = fit ?? BoxFit.cover;
  final Size size;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;
  final String src;
  final String? defaultSrc;
  final Widget? defaultImage;
  final bool useCachedNetworkImage;
  final BoxFit fit;

  Size get imgSize => Size(size.width - borderWidth * 2, size.height - borderWidth * 2);
  final Widget empty = const SizedBox(width: 0, height: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: borderWidth,
          color: borderColor,
        ),
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: buildImageWidget(),
    );
  }

  Widget buildImageWidget() {
    if (src == "") {
      return defaultImage != null ? defaultImage! : buildDefaultImage(defaultSrc ?? "");
    }
    return buildImage(src);
  }

  Widget buildDefaultImage(String src) {
    if (src == "") return empty;
    return buildImage(src);
  }

  Widget buildImage(String src) {
    if (src.startsWith("http://") || src.startsWith("https://")) {
      return useCachedNetworkImage
          ? CachedNetworkImage(
              imageUrl: src,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              width: imgSize.width,
              height: imgSize.height,
              fit: fit,
            )
          : Image.network(
              src,
              width: imgSize.width,
              height: imgSize.height,
              fit: fit,
            );
    } else if (src.startsWith("/")) {
      var f = File(src);
      if (f.existsSync()) {
        return Image.file(
          f,
          width: imgSize.width,
          height: imgSize.height,
          fit: fit,
        );
      }
      return empty;
    } else {
      return Image.asset(
        src,
        width: imgSize.width,
        height: imgSize.height,
        fit: fit,
      );
    }
  }
}
