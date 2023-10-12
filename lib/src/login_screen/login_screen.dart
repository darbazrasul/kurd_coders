import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_helper.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/home_screen/main_screen.dart';
import 'package:kurd_coders/src/login_screen/registration_screen.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailTEC = TextEditingController(text: "info@ztech.krd");
  var passwordTEC = TextEditingController(text: '12345678');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      body: Stack(children: [
        _body,
        KWidget.loadingView(isLoading),
      ]),
    );
  }

  Widget get _body {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            bannerView,
            SizedBox(height: 30),
            // emailTextField,
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
            SizedBox(height: 30),
            loginBtn,
            SizedBox(height: 30),
            registrationBtn,
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
            "LOGIN",
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
        login();
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

  Widget get registrationBtn {
    return GestureDetector(
      onTap: () {
        Get.to(() => RegistrationScreen());
      },
      child: Center(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Don’t have a account!? ",
              style: TextStyle(
                color: KColors.black,
              ),
            ),
            TextSpan(
              text: "Register NOW",
              style: TextStyle(
                  color: KColors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1),
            ),
          ]),
        ),
      ),
    );
  }

  void login() async {
    String? email = emailTEC.text;
    String? password = passwordTEC.text;

    if (!email.isEmail) {
      KHelper.showSnackBar("PLease enter the email!!!");
      return;
    }
    if (password.length < 8) {
      KHelper.showSnackBar("Password should be more than 8 character!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        KHelper.showSnackBar('Welcome!');

        var userUID = credential.user!.uid;

        await Provider.of<AuthProvide>(context, listen: false)
            .fetchUserData(userUID);

        Get.offAll(() => MainScreen());
      } else {
        KHelper.showSnackBar('Error: 4564');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        KHelper.showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        KHelper.showSnackBar('Wrong password provided for that user.');
      }
    }
  }
}
