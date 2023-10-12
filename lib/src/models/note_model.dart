import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NoteModel {
  String? uid;
  String? note;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  NoteModel({
    this.uid,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  static NoteModel fromMap(Map<String, dynamic> map) {
    return NoteModel(
      uid: map["uid"],
      note: map["note"],
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "note": note,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  // create
  Future<void> create() async {
    uid ??= const Uuid().v1();

    await FirebaseFirestore.instance.collection("notes").doc(uid).set(toMap());
  }

  // update
  Future<void> update() async {
    updatedAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(uid)
        .update(toMap());
  }

  // delete
  Future<void> delete() async {
    await FirebaseFirestore.instance.collection("notes").doc(uid).delete();
  }
}
