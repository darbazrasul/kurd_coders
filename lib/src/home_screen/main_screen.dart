// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/home_screen/screens/add_new_post_scree.dart';
import 'package:kurd_coders/src/home_screen/screens/home_screen.dart';
import 'package:kurd_coders/src/home_screen/screens/profile_screen.dart';
import 'package:kurd_coders/src/providers/app_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: _myNavigationBar,
        backgroundColor: Colors.grey.shade300,
        body: Stack(
          children: [
            Positioned.fill(child: _body),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _myNavigationBar,
            ),
          ],
        ));
  }

  Widget get _body {
    switch (Provider.of<AppProvider>(context).selectedNavigatorIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  Widget get _myNavigationBar {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withAlpha(100),
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          navigationCell(
              title: "Home", imagePath: Assets.resourceIconsHomeIcon, index: 0),
          navigationCell(
              title: "Home",
              imagePath: Assets.resourceIconsHomeIcon,
              index: -1),
          navigationCell(
              title: "Profile",
              imagePath: Assets.resourceIconsProfile,
              index: 1),
        ],
      ),
    );
  }

  Widget navigationCell({
    required String title,
    required String imagePath,
    required int index,
  }) {
    var isSelected =
        Provider.of<AppProvider>(context).selectedNavigatorIndex == index;

    if (index == -1) {
      return Transform.translate(
        offset: Offset(0, -10),
        child: GestureDetector(
          onTap: () {
            Get.to(() => AddNewPostScreen());
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffF7E987),
            ),
            child: Icon(
              Icons.add_rounded,
              size: 40,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Provider.of<AppProvider>(context, listen: false).changeIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? Color(0xff5e9c8d) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(10),
            child: Image.asset(
              imagePath,
              width: 16,
              height: 16,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
