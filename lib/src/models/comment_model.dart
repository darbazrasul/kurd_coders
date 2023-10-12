import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? uid;
  String? userUid;
  String? comment;
  Timestamp? createdAt;

  CommentModel({
    this.uid,
    this.userUid,
    this.comment,
    this.createdAt,
  });

  // fromMap
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uid: map['uid'],
      userUid: map['userUid'],
      comment: map['comment'],
      createdAt: map['createdAt'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "userUid": userUid,
      "comment": comment,
      "createdAt": createdAt,
    };
  }

  Future create(String postUID) async {
    createdAt ??= Timestamp.now();
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postUID)
        .collection("comments")
        .doc(uid)
        .set(toMap());
  }

  Future delete(String postUID) async {
    createdAt ??= Timestamp.now();
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postUID)
        .collection("comments")
        .doc(uid)
        .delete();
  }
}


// jsonFIle

/* [
    [
      "uid" : "1",
      "userUid" : "213",
      "comment" : "Hi",
      "createdAt" : "2023",
    ],
    [
      "uid" : "1",
      "userUid" : "213",
      "comment" : "Hi",
      "createdAt" : "2023",
    ],
    [
      "uid" : "1",
      "userUid" : "213",
      "comment" : "Hi",
      "createdAt" : "2023",
    ],
    [
      "uid" : "1",
      "userUid" : "213",
      "comment" : "Hi",
      "createdAt" : "2023",
    ],
    [
      "uid" : "1",
      "userUid" : "213",
      "comment" : "Hi",
      "createdAt" : "2023",
    ],


] */