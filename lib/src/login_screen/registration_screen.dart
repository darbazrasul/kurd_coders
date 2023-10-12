// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_helper.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/home_screen/main_screen.dart';
import 'package:kurd_coders/src/models/user_model.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var nameTEC = TextEditingController();
  var usernameTEC = TextEditingController();
  var emailTEC = TextEditingController(text: "info@ztech.krd");
  var passwordTEC = TextEditingController(text: '12345678');
  var password2TEC = TextEditingController(text: '12345678');

  DateTime? userBirthday;
  File? imageFile;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      body: Stack(
        children: [_body, KWidget.loadingView(isLoading)],
      ),
    );
  }

  Widget get _body {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            bannerView,
            SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey.shade400,
              backgroundImage: imageFile == null
                  ? CachedNetworkImageProvider(
                      "https://firebasestorage.googleapis.com/v0/b/fastday-platform.appspot.com/o/1650151825248?alt=media&token=79196c87-152d-4955-a981-2180ba95926c")
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
            KTextField(
              title: "Email",
              hint: 'name@example.com',
              controller: emailTEC,
              icon: Assets.resourceIconsMail,
            ),
            KTextField(
              isPassword: true,
              title: "Password",
              controller: passwordTEC,
              icon: Assets.resourceIconsPassword,
            ),
            KTextField(
              isPassword: true,
              title: "Confirm password",
              controller: password2TEC,
              icon: Assets.resourceIconsPassword,
            ),
            SizedBox(
              height: 20,
            ),

            KWidget.btnLarge(
                title: "Register",
                image: Assets.resourceIconsSave,
                color: KColors.text.shade50,
                bgColor: KColors.primaryColor,
                onTap: () {
                  register();
                }),
            SizedBox(
              height: 50,
            ),

            SizedBox(
              height: 50,
            ),
            // Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget get bannerView {
    return Stack(
      children: [
        Image.asset(Assets.resourceImagesLoginBgTop),
        Positioned(
          top: 30,
          left: 40,
          child: Text(
            "REGISTER",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            Assets.resourceIconsLogo,
            width: 100,
            height: 100,
          ),
        )
      ],
    );
  }

  Widget get loginBtn {
    return GestureDetector(
      onTap: () {
        Get.off(() => MainScreen());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (contex) => MainScreen()));
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF7E987),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black.withAlpha(100),
                offset: Offset(2, 4),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 25),
              Image.asset(
                Assets.resourceIconsIconLogin,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            milliseconds: 31556926000 * 13,
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

  register() async {
    //1- Check user inputs
    String? email = emailTEC.text;
    String? password = passwordTEC.text;
    String? password2 = password2TEC.text;
    String? name;
    String? username;
    Timestamp? birthday;

    if (nameTEC.text.length < 3) {
      KHelper.showSnackBar("Name should be more than 3 character");
      return;
    }
    name = nameTEC.text;
    if (usernameTEC.text.length < 3) {
      KHelper.showSnackBar("Name should be more than 3 character");
      return;
    }
    username = usernameTEC.text.toLowerCase();

    if (userBirthday != null) {
      birthday = Timestamp.fromDate(userBirthday!);
      return;
    }

    if (!email.isEmail) {
      KHelper.showSnackBar("PLease enter the email!!!");
      return;
    }

    if (password != password2) {
      KHelper.showSnackBar("Password don't much");
    }

    if (password.length < 8) {
      KHelper.showSnackBar("Password should be more than 8 character!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      //2 - Register the user email and pass
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var userUID = credential.user!.uid;

      String? imgUrl;

      //3 if the user selected an image then uploaded
      if (imageFile != null) {
        imgUrl = await uploadMedia(imageFile!, userUID);
      }

      //4 save user data to firestore
      UserModel mUser = UserModel(
        avatarUrl: imgUrl,
        bio: null,
        birthday: birthday,
        email: email,
        uid: userUID,
        name: name,
        username: username,
      );

      await mUser.create();

      await Provider.of<AuthProvide>(context, listen: false)
          .fetchUserData(userUID);
      //5 open the app

      Get.offAll(() => MainScreen());
    } on FirebaseAuthException catch (e) {
      print("object 3: ${e.code}");
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        KHelper.showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        KHelper.showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      print("e: $e");
      KHelper.showSnackBar(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<String?> uploadMedia(File myImageFile, String userUID) async {
    var ref = FirebaseStorage.instance.ref().child("users").child(userUID);

    var uploadFileName = "avatar.png";
    ref = ref.child(uploadFileName);

    try {
      await ref.putFile(myImageFile);
    } on FirebaseException catch (e) {
      print(e.message.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error while uploading the image")));

      return null;
    }

    var downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }
}
