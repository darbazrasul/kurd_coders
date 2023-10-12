import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/home_screen/main_screen.dart';
import 'package:kurd_coders/src/login_screen/login_screen.dart';
import 'package:kurd_coders/src/providers/app_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Provider.of<AppProvider>(context).isDarkMood
            ? Brightness.dark
            : Brightness.light,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? LoginScreen()
          : MainScreen(),
    );
  }
}
