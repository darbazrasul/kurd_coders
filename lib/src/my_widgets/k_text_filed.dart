import 'package:flutter/material.dart';

class KTextField extends StatelessWidget {
  /// Sets the tooltip to [lines], which should have been word wrapped using
  /// the current font. `test`
  /// ```
  /// var title = "Hello World"
  ///
  /// ```
  ///This is a test code [for this bracket]
  const KTextField({
    super.key,
    this.controller,
    this.title,
    this.hint,
    this.icon,
    this.isEnable = true,
    this.isPassword = false,
    this.onTap,
    this.dynamicHeight = false,
    this.suffixIcon,
    this.focusNode,
  });

  final TextEditingController? controller;

  ///This is the title for the head of textfield
  final String? title;
  final String? hint;
  final String? icon;
  final bool isEnable;
  final bool isPassword;
  final Function()? onTap;
  final bool dynamicHeight;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(right: 16, left: 25, bottom: 0, top: 5),
                  child: Row(
                    children: [
                      Text(title!),
                    ],
                  ),
                ),
              ],
            ),
          Container(
            margin: EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                children: [
                  // icon
                  if (icon != null) ...[
                    Image.asset(
                      icon!,
                      width: 18,
                      height: 18,
                      color: isEnable
                          ? Colors.black
                          : Colors.black.withOpacity(0.5),

                      // Only for learning Decimal, Hexa, Octa , Binary
                      // EEFE459E
                      //0,1..8,9 =? 10, 11 ,, 18, 19
                      // 0,1,2 .. 8,9,A,B,C,D,E,F  => 10 ... 18,19,1A,1B,1C,1D,1E, 1F / 20... 2F
                      // 0, 1,
                      // 10, 11
                      //100 // 101/ 110 / 111
                      // 0,1..6,7 10 17 20 27
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                  // textFelid
                  if (onTap == null)
                    Expanded(
                      child: TextField(
                        obscureText: isPassword,
                        enabled: isEnable,
                        controller: controller,
                        decoration: InputDecoration(
                            suffixIcon: suffixIcon,
                            border: InputBorder.none,
                            hintText: hint),
                        maxLines: dynamicHeight ? null : 1,
                        focusNode: focusNode,
                      ),
                    ),
                  if (onTap != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        controller?.text != null && controller!.text.isNotEmpty
                            ? (controller?.text ?? "")
                            : (hint ?? ""),
                        style: TextStyle(
                            color: controller?.text != null &&
                                    controller!.text.isNotEmpty
                                ? Colors.black
                                : Colors.black45),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
