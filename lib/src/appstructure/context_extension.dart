import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  ///
  EdgeInsets get safeAreaInsets => MediaQuery.of(this).viewPadding;

  ///
  double get keyboardAvoidingHeight => MediaQuery.of(this).viewInsets.bottom;

  ///
  Size get windowSize => MediaQuery.of(this).size;
}
