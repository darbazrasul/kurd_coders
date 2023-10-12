import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kurd_coders/src/models/user_model.dart';

class AuthProvide extends ChangeNotifier {
  AuthProvide() {
    var userUid = FirebaseAuth.instance.currentUser?.uid;

    if (userUid != null) {
      fetchUserData(userUid);
    }
  }

  UserModel? myUser;

  fetchUserData(String userIud) async {
    var userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userIud).get();
    if (userDoc.exists) {
      myUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    }

    notifyListeners();
  }

  signOut() {
    myUser = null;
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
