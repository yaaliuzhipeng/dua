import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiOverlayData {
  SystemUiOverlayStyle? style;
  List<SystemUiOverlay>? overlays;
}

class SystemUiOverlayerManager {
  static SystemUiOverlayerManager? instance;

  static SystemUiOverlayerManager get shared => instance ??= SystemUiOverlayerManager();

  SystemUiOverlayData? _data;

  static SystemUiOverlayData? get latestData => SystemUiOverlayerManager.shared._data;

  static void setLatestData(SystemUiOverlayData? v) {
    SystemUiOverlayerManager.shared._data = v;
  }
}

class SystemUiOverlayerController {
  late void Function({
    Brightness? brightness,
    Color? backgroundColor,
    bool? prefersStatusBarHidden,
    bool? prefersHomeIndicatorHidden,
  }) setUiOverlay;
}

class SystemUiOverlayer extends StatefulWidget {
  const SystemUiOverlayer({
    super.key,
    bool? enabled,
    this.brightness,
    this.backgroundColor,
    this.prefersStatusBarHidden,
    this.prefersHomeIndicatorHidden,
    this.controller,
  }) : enabled = enabled ?? true;

  final bool enabled;
  final SystemUiOverlayerController? controller;
  final Brightness? brightness;
  final Color? backgroundColor;
  final bool? prefersStatusBarHidden;
  final bool? prefersHomeIndicatorHidden;

  @override
  State<SystemUiOverlayer> createState() => _SystemUiOverlayerState();
}

class _SystemUiOverlayerState extends State<SystemUiOverlayer> {
  SystemUiOverlayData? previousOverlayData;

  void setUiOverlay({
    Brightness? brightness,
    Color? backgroundColor,
    bool? prefersStatusBarHidden,
    bool? prefersHomeIndicatorHidden,
  }) {
    if (Platform.isIOS && brightness != null) {
      brightness = brightness == Brightness.light ? Brightness.dark : Brightness.light;
    }
    //
    SystemUiOverlayStyle v = SystemUiOverlayStyle(
      //property only work in ios
      statusBarBrightness: brightness,
      //property for android
      statusBarIconBrightness: brightness,
      statusBarColor: backgroundColor ?? Colors.transparent,
    );
    List<SystemUiOverlay>? overlays;
    if (prefersStatusBarHidden != null) {
      overlays ??= [];
      if (prefersStatusBarHidden == false) overlays.add(SystemUiOverlay.top);
    }
    if (prefersHomeIndicatorHidden != null) {
      overlays ??= [];
      if (prefersHomeIndicatorHidden == false) overlays.add(SystemUiOverlay.bottom);
    }
    var data = SystemUiOverlayData();
    data.style = v;
    data.overlays = overlays;
    SystemUiOverlayerManager.setLatestData(data);
    SystemChrome.setSystemUIOverlayStyle(v);
    if (overlays != null) SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: overlays);
  }

  @override
  void initState() {
    previousOverlayData = SystemUiOverlayerManager.latestData;
    if (widget.controller != null) {
      widget.controller!.setUiOverlay = setUiOverlay;
    }
    if (widget.enabled) {
      setUiOverlay(
        brightness: widget.brightness,
        backgroundColor: widget.backgroundColor,
        prefersStatusBarHidden: widget.prefersStatusBarHidden,
        prefersHomeIndicatorHidden: widget.prefersHomeIndicatorHidden,
      );
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SystemUiOverlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      setUiOverlay(
        brightness: widget.brightness,
        backgroundColor: widget.backgroundColor,
        prefersStatusBarHidden: widget.prefersStatusBarHidden,
        prefersHomeIndicatorHidden: widget.prefersHomeIndicatorHidden,
      );
    }
  }

  @override
  void dispose() {
    //restore previous overlay info;
    if (previousOverlayData != null) {
      Brightness? brightness = previousOverlayData?.style?.statusBarBrightness;
      if (brightness != null) {
        brightness = brightness == Brightness.light ? Brightness.dark : Brightness.light;
      }
      setUiOverlay(
        brightness: brightness,
        backgroundColor: previousOverlayData?.style?.statusBarColor,
        prefersStatusBarHidden: previousOverlayData?.overlays == null ? null : (previousOverlayData!.overlays)!.contains(SystemUiOverlay.top) == false,
        prefersHomeIndicatorHidden: previousOverlayData?.overlays == null ? null : previousOverlayData!.overlays!.contains(SystemUiOverlay.bottom) == false,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 0, height: 0);
  }
}
