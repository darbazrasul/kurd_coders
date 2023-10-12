
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? username;
  String? name;
  String? bio;
  String? email;
  String? avatarUrl;
  Timestamp? birthday;

  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserModel({
    this.uid,
    this.username,
    this.name,
    this.bio,
    this.email,
    this.avatarUrl,
    this.birthday,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'name': name,
      'bio': bio,
      'email': email,
      'avatarUrl': avatarUrl,
      'birthday': birthday,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      birthday: map['birthday'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // create
  Future<void> create() async {
    createdAt ??= Timestamp.now();
    updatedAt ??= Timestamp.now();
    await FirebaseFirestore.instance.collection("users").doc(uid).set(toMap());
  }

  // update
  Future<void> update() async {
    updatedAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update(toMap());
  }

  // delete
  Future<void> delete() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
  }
}
