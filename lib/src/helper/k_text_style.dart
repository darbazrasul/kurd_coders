import 'package:flutter/material.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';

class KTextStyle {
  static TextStyle textColorLight(double size) {
    return TextStyle(
      color: KColors.text.shade50,
      fontSize: size,
    );
  }

  static TextStyle textColorDark(double size) {
    return TextStyle(
      color: KColors.text.shade900,
      fontSize: size,
    );
  }
}
