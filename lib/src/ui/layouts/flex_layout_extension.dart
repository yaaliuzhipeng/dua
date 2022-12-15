import 'package:flutter/material.dart';

extension HorizontalLayoutExtension on List<Widget> {
  /// start
  hs({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// center
  hc({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// end
  he({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// space-between
  hsb({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// space-around
  hsa({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  /// space-evenly
  hse({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}

extension VerticalLayoutExtension on List<Widget> {
  vs({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  vc({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  ve({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  vsb({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  vsa({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  vse({
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}
