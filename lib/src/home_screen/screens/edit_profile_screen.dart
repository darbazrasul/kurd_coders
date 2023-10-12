// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_helper.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/login_screen/login_screen.dart';
import 'package:kurd_coders/src/models/user_model.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class EditPRofileScreen extends StatefulWidget {
  const EditPRofileScreen({super.key});

  @override
  State<EditPRofileScreen> createState() => _EditPRofileScreenState();
}

class _EditPRofileScreenState extends State<EditPRofileScreen> {
  var bioTEC = TextEditingController();
  var nameTEC = TextEditingController();
  var usernameTEC = TextEditingController();
  var emailTEC = TextEditingController();
  DateTime? userBirthday;
  File? imageFile;

  String? userAvatarUrl;

  bool isLoading = false;

  loadData() {
    UserModel? user = Provider.of<AuthProvide>(context, listen: false).myUser;

    if (user == null) {
      Get.back();
    }

    bioTEC.text = user?.bio ?? "";
    nameTEC.text = user?.name ?? "";
    usernameTEC.text = user?.username ?? "";
    emailTEC.text = user?.email ?? "";
    userBirthday = user?.birthday?.toDate();

    userAvatarUrl = user?.avatarUrl;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: _appBar,
      body: _bodyLayout,
    );
  }

  get _bodyLayout => Stack(
        children: [
          _body,
          _loadingView,
        ],
      );

  get _loadingView => isLoading
      ? BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withAlpha(0),
            width: double.infinity,
            height: double.infinity,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(
                  strokeWidth: 10,
                  semanticsValue: "Loading",
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Saving Data ...")
              ],
            )),
          ),
        )
      : Container();

  get _body => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey.shade400,
                backgroundImage: imageFile == null
                    ? Image.network(userAvatarUrl ?? "").image
                    : Image.file(imageFile!).image,
              ),
              SizedBox(
                height: 20,
              ),
              KWidget.btnMedium(
                title: "Select Image",
                image: Assets.resourceIconsAddImage,
                color: KColors.text.shade900,
                bgColor: KColors.primaryColor,
                onTap: () {
                  pickImage();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 16, left: 25, bottom: 0, top: 5),
                    child: Text("BIO"),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 16, left: 16, bottom: 16, top: 5),
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
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: bioTEC,
                        decoration: InputDecoration(border: InputBorder.none),
                        // maxLines: 5,
                        maxLines: null,
                        maxLength: 255,
                      ),
                    ),
                  ),
                ],
              ),
              KTextField(
                title: "Name",
                hint: 'Full name',
                controller: nameTEC,
              ),
              KTextField(
                controller: usernameTEC,
                title: "Username",
                hint: 'karamzeway',
                icon: Assets.resourceIconsAt,
              ),
              KTextField(
                isEnable: false,
                title: "Email",
                hint: 'name@example.com',
                controller: emailTEC,
                icon: Assets.resourceIconsMail,
              ),
              // Bo chi l vere Row qabil naket
              KTextField(
                title: 'Birthday',
                hint: '1990/05/01',
                controller: userBirthday == null
                    ? null
                    : TextEditingController(
                        text: DateFormat("yyyy/MM/d").format(userBirthday!)),
                icon: Assets.resourceIconsBirthday,
                onTap: () {
                  pickDate();
                },
              ),
              SizedBox(
                height: 20,
              ),

              KWidget.btnLarge(
                  title: "Save",
                  image: Assets.resourceIconsSave,
                  color: KColors.text.shade50,
                  bgColor: KColors.primaryColor,
                  onTap: () {
                    showAlertToSave();
                  }),
              SizedBox(
                height: 50,
              ),
              KWidget.btnMedium(
                  title: "logout",
                  bgColor: KColors.dangerColor,
                  color: KColors.white,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => LoginScreen());

                    /*  Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false); */
                  }),
              SizedBox(
                height: 50,
              ),
              /* KWidget.btnMedium(
                  title: "Change to Home ",
                  bgColor: KColors.successColor,
                  color: KColors.white,
                  onTap: () {
                    Provider.of<AppProvider>(context, listen: false)
                        .changeIndex(0);
                    
      Get.back();
                  }), */
            ],
          ),
        ),
      );

  get _appBar => AppBar(
        leading: _appBarBackIcon,
        leadingWidth: 70,
        backgroundColor: Colors.grey.shade400,
        actions: [
          _appBarSaveIcon,
        ],
      );

  get _appBarSaveIcon => GestureDetector(
        onTap: () {
          showAlertToSave();
        },
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xff64A09A),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                Assets.resourceIconsSave,
                width: 22,
                height: 22,
              ),
            ),
          ),
        ),
      );

  get _appBarBackIcon => Center(
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                Assets.resourceIconsLeftArrow,
                width: 22,
                height: 22,
              ),
              Text(
                "Bcak",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      );

  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now().subtract(
          Duration(
            milliseconds: 31556926000 * 13,
          ),
        ),
        firstDate:
            DateTime.now().subtract(Duration(milliseconds: 31556926000 * 100)),
        lastDate: DateTime.now().subtract(
          Duration(
            milliseconds: 31556926000 * 5,
          ),
        ));

    if (pickedDate != null) {
      userBirthday = pickedDate;
      setState(() {});
    }
  }

  void pickImage() async {
    File? pickedImage = await KHelper.pickImageFromGallery(cropTheImage: true);
    if (pickedImage != null) {
      imageFile = pickedImage;
    }
    setState(() {});
  }

  showAlertToSave() {
    if (isLoading) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Save"),
        content: Text("Do you want to save the changes?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              save();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void save() async {
    if (usernameTEC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username is empty"),
          backgroundColor: KColors.dangerColor,
        ),
      );
      return;
    }

    if (userBirthday?.isAfter(DateTime.now().subtract(
          Duration(
            milliseconds: 31556926000 * 13,
          ),
        )) ??
        true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Birthday is not valid"),
          backgroundColor: KColors.dangerColor,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    UserModel? user = Provider.of<AuthProvide>(context, listen: false).myUser;

    // TODO: save to database
    user?.bio = bioTEC.text;
    user?.name = nameTEC.text;
    user?.username = usernameTEC.text;
    if (userBirthday != null) {
      user?.birthday = Timestamp.fromDate(userBirthday!);
    }

    Provider.of<AuthProvide>(context, listen: false).myUser = user;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Data saved to database successfully"),
        backgroundColor: KColors.successColor,
      ),
    );

    Get.back();
  }
}

/* 
test() {
  // only for Learning
  String? name;

  var ar1 = [
    1,
    if (name != null) 2,
    if (name != null) 3,
    if (name != null) 4,
  ];

  var ar1_v2 = [
    1,
    if (name != null) ...[
      2,
      3,
      4,
    ]
  ];

  var arr2 = [546, 654, 6541];

  List<int> mArr = [45, ...ar1];

  List<int> mArr2 = [
    45,
    if (name == "computer") ...[1, 2, 3, 4, 5],
  ];

  print(mArr2); // 45,1,2,3,4,5

  List<int> mArr3 = [
    45,
    if (name == "laptop") ...[1, 2, 3, 4, 5],
  ];

  print(mArr2); // 45
}
 */
