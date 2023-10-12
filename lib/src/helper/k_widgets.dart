import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_text_style.dart';

class KWidget {
  static Widget btnMedium(
      {String? title,
      String? image,
      Color? bgColor = KColors.accentColor,
      Color? color,
      Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
          color: bgColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 15),
            Text(
              title ?? "",
              style: KTextStyle.textColorDark(16).copyWith(
                color: color ?? KTextStyle.textColorDark(20).color,
              ),
            ),
            SizedBox(width: 15),
            if (image != null)
              Image.asset(
                image,
                width: 22,
                height: 22,
                color: color ?? KColors.text.shade800,
              ),
          ],
        ),
      ),
    );
  }

  static Widget btnLarge(
      {String? title,
      String? image,
      Color? bgColor = KColors.accentColor,
      Color? color,
      Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
          color: bgColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: KTextStyle.textColorDark(20).copyWith(
                  color: color ?? KTextStyle.textColorDark(20).color,
                ),
              ),
            ),
            if (image != null)
              Image.asset(
                image,
                width: 28,
                height: 28,
                color: color ?? KColors.text.shade800,
              ),
          ],
        ),
      ),
    );
  }

  static loadingView(bool isLoading, {String? text}) {
    if (isLoading) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                if (text != null) Text(text)
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
