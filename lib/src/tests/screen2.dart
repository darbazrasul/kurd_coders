import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/tests/screen3.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "B",
              style: TextStyle(fontSize: 100),
            ),
            KWidget.btnLarge(
                title: "to C",
                onTap: () {
                  Get.offAll(() => Screen3());
                })
          ],
        ),
      ),
    );
  }
}
