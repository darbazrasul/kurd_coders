import 'package:flutter/material.dart';

class KColors {
  static const Color white = Color.fromARGB(255, 242, 242, 242);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color accentColor = Color(0xFFF7E987);
  static const Color primaryColor = Color(0xFF5B9A8B);
  static const Color primaryColorDark = Color(0xFF445069);
  static const Color darkColor = Color(0xFF252B48);
  static const Color successColor = Color.fromARGB(255, 20, 175, 17);
  static const Color dangerColor = Color.fromARGB(255, 209, 76, 102);
  static const Color blue = Color.fromARGB(255, 62, 94, 236);

  //color with shades
  static MaterialColor get mainColor => const MaterialColor(0xFFF7E987, {
        50: Color.fromRGBO(247, 233, 135, .1),
        100: Color.fromRGBO(247, 233, 135, .2),
        200: Color.fromRGBO(247, 233, 135, .3),
        300: Color.fromRGBO(247, 233, 135, .4),
        400: Color.fromRGBO(247, 233, 135, .5),
        500: Color.fromRGBO(247, 233, 135, .6),
        600: Color.fromRGBO(247, 233, 135, .7),
        700: Color.fromRGBO(247, 233, 135, .8),
        800: Color.fromRGBO(104, 92, 2, 0.898),
        900: Color.fromRGBO(56, 50, 1, 1),
      });

  static MaterialColor get text => const MaterialColor(0xff505862, {
        50: Color(0xffffffff),
        100: Color(0xffF7F6F5),
        200: Color.fromARGB(255, 208, 255, 235),
        300: Color(0xff727c8e),
        400: Color(0xff727C8E),
        500: Color(0xff545454),
        600: Color(0xff002042),
        700: Color.fromARGB(255, 33, 48, 64),
        800: Color(0xff002042),
        900: Color(0xff002042),
      });
}
