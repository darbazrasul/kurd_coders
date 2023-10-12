// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:kurd_coders/src/firebase_test_screen_all_data.dart';
import 'package:kurd_coders/src/firestore_test_screen.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';

import 'package:kurd_coders/src/home_screen/screens/edit_profile_screen.dart';
import 'package:kurd_coders/src/providers/app_provider.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:kurd_coders/src/tests/screen1.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthProvide? authProvider;
  AppProvider? appProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvide>(context);
    appProvider = Provider.of<AppProvider>(context);

    /* if (appProvider?.myUser == null) {
      return Scaffold(
        body: Center(
          child: KWidget.btnLarge(
              title: "Please Sign in",
              onTap: () {
                appProvider!.signInTheUser("salar@salar.com");
              }),
        ),
      );
    } */

    return Scaffold(
      // backgroundColor: appProvider!.isDarkMood ? Colors.black : Colors.white,
      /* appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            appProvider?.changeIndex(0);
          },
        ),
      ), */

      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                Assets.resourceImagesProfileBgTop,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 120,
                child: Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: Image.network(authProvider
                                ?.myUser?.avatarUrl ??
                            "https://firebasestorage.googleapis.com/v0/b/fastday-platform.appspot.com/o/1650151825248?alt=media&token=79196c87-152d-4955-a981-2180ba95926c")
                        .image,
                  ),
                ),
              ),
              if (authProvider?.myUser?.birthday != null)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 120,
                  child: Center(
                    child: CircularText(
                      children: [
                        TextItem(
                          text: Text(
                            DateFormat("yyyy M d").format(
                                authProvider!.myUser!.birthday!.toDate()),
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // space: 7,
                          startAngle: -90,
                          startAngleAlignment: StartAngleAlignment.center,
                          direction: CircularTextDirection.clockwise,
                        ),
                      ],
                      radius: 70,
                      position: CircularTextPosition.outside,
                      backgroundPaint: Paint()..color = Colors.transparent,
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authProvider?.myUser?.name ?? "N/A",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            Assets.resourceIconsVerified,
                            width: 30,
                            height: 30,
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "@${authProvider?.myUser?.username ?? "N/A"}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                  onTap: () {
                    Get.to(EditPRofileScreen());
                    /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ))
                        .then((value) {
                      setState(() {});
                    }); */
                  },
                  child: SafeArea(
                    child: Image.asset(
                      Assets.resourceIconsEdit,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: GestureDetector(
                  onTap: () {
                    authProvider?.signOut();
                  },
                  child: SafeArea(
                    child: Icon(Icons.logout),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 30),
          if (authProvider?.myUser?.bio != null)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black.withAlpha(100),
                    offset: Offset(2, 4),
                  )
                ],
              ),
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bio",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(authProvider?.myUser?.bio ?? ""),
                ],
              ),
            ),
          KWidget.btnMedium(
              title: "TESTS",
              onTap: () {
                Get.to(() => FirebaseTestScreen());
              }),
          KWidget.btnMedium(
              title: "TESTS BULK Data",
              onTap: () {
                Get.to(() => FirebaseTestBulkData());
              }),
          KWidget.btnMedium(
              title: "Show Posts",
              onTap: () {
                Get.to(() => Screen1());
                // Provider.of<AppProvider>(context, listen: false).changeIndex(0);
              }),
          Switch(
              value: appProvider!.isDarkMood,
              onChanged: (value) {
                appProvider!.updateAppearance(value);
              }),
        ],
      ),
    );
  }
}
