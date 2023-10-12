import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/tests/screen1.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("C",style: TextStyle(fontSize: 100),),
            KWidget.btnLarge(
                title: "A",
                onTap: () {
                  Get.to(() => Screen1());
                }),
          ],
        ),
      ),
    );
  }
}
