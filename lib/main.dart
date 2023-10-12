import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kurd_coders/firebase_options.dart';
import 'package:kurd_coders/src/my_app/my_app.dart';
import 'package:kurd_coders/src/providers/app_provider.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvide()),
    ],
    child: const MyApp(),
  ));
}
