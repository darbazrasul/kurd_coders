import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kurd_coders/src/models/comment_model.dart';
import 'package:uuid/uuid.dart';

class PostModel {
  String? uid;
  String? userUid;
  String? text;
  String? imageUrl;

  List<String>? likesUserUID;

  Timestamp? createdAt;
  Timestamp? updateAt;

  PostModel({
    this.uid,
    this.userUid,
    this.text,
    this.imageUrl,
    this.likesUserUID,
    this.createdAt,
    this.updateAt,
  });

  // fromMap
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'],
      userUid: map['userUid'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      likesUserUID: List<String>.from(map['likesUserUID']),
      createdAt: map['createdAt'],
      updateAt: map['updateAt'],
    );
  }

  // toMap
  Map<String, dynamic> toMap({allFields = false}) {
    return {
      "uid": uid,
      "userUid": userUid,
      "text": text,
      "imageUrl": imageUrl,
      if (allFields) "likesUserUID": likesUserUID,
      "createdAt": createdAt,
      "updateAt": updateAt,
    };
  }

  // create
  Future<void> create() async {
    uid ??= const Uuid().v4();
    createdAt ??= Timestamp.now();
    updateAt ??= Timestamp.now();
    likesUserUID ??= [];

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(uid)
        .set(toMap(allFields: true));
  }

  // update
  Future<void> update() async {
    updateAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(uid)
        .update(toMap());
  }

  // update
  Future<void> updateLike({required String userId, required bool isAdd}) async {
    await FirebaseFirestore.instance.collection("posts").doc(uid).update({
      if (isAdd) "likesUserUID": FieldValue.arrayUnion([userId]),
      if (!isAdd) "likesUserUID": FieldValue.arrayRemove([userId]),
    });
  }

  // update
  Future<void> addComment({required CommentModel comment}) async {
    await comment.create(uid!);
  }

  Future<void> removeComment({required CommentModel comment}) async {
    await comment.delete(uid!);
  }

  // delete
  Future<void> delete() async {
    await FirebaseFirestore.instance.collection("posts").doc(uid).delete();
  }

  static Stream<List<PostModel>> streamAll() {
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshotData) =>
            snapshotData.docs.map((e) => PostModel.fromMap(e.data())).toList());
  }

  Stream<List<CommentModel>> streamAllComments() {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(uid!)
        .collection("comments")
        .orderBy("createdAt")
        .snapshots()
        .map((snapshotData) => snapshotData.docs
            .map((e) => CommentModel.fromMap(e.data()))
            .toList());
  }

  static Stream<PostModel> streamOne(String? docID) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(docID)
        .snapshots()
        .map((snapshotData) =>
            PostModel.fromMap(snapshotData.data() as Map<String, dynamic>));
  }
}

// mapping data in Dart
/* test() {
  List<Map<String, String>> list = [
    {"num": "1"}, //
    {"num": "2"},
    {"num": "3"},
    {"num": "4152"},
    {"num": "51"}
  ];

  List<int> intList =
      list.map((e) => int.parse(e['num']!)).toList(); //=> [1, 2, 3, 4152, 51];
}
 */