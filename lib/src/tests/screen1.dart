import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/tests/screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "A",
              style: TextStyle(fontSize: 100),
            ),
            KWidget.btnLarge(
                title: "to B",
                onTap: () {
                  Get.to(() => Screen2());
                })
          ],
        ),
      ),
    );
  }
}
