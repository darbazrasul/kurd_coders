import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_text_style.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/models/note_model.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';

class FirebaseTestBulkData extends StatefulWidget {
  const FirebaseTestBulkData({super.key});

  @override
  State<FirebaseTestBulkData> createState() => _FirebaseTestBulkDataState();
}

class _FirebaseTestBulkDataState extends State<FirebaseTestBulkData> {
  var noteETC = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _bodyLayout,
    );
  }

  get _bodyLayout => Stack(
        children: [
          _body,
          KWidget.loadingView(isLoading, text: "Loading.."),
        ],
      );

  get _body => Column(
        children: [
          KTextField(
            controller: noteETC,
            hint: "Note",
          ),
          KWidget.btnMedium(
              title: "Create",
              onTap: () {
                createNewNote();
              }),
          Divider(
            thickness: 1,
            height: 0,
          ),
          _noteList,
        ],
      );

  Widget get _noteList => Expanded(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("notes")
              .orderBy("updatedAt", descending: true)
              .snapshots(),
          builder: (context, snpashot) {
            if (snpashot.data == null) {
              return KWidget.loadingView(true);
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> myDocs =
                snpashot.data!.docs;

            List<NoteModel> myNotes = [];
            for (var note in myDocs) {
              var noteModel = NoteModel.fromMap(note.data());
              myNotes.add(noteModel);
            }

            return ListView.builder(
              itemCount: myNotes.length,
              itemBuilder: (context, index) {
                return noteCellView(myNotes[index], index);
              },
            );
          },
        ),
      );

  Container noteCellView(NoteModel noteModel, index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${index + 1}"),
              Container(
                width: 1,
                height: 20,
                color: Colors.black,
              ),
              Expanded(
                child: Text(
                  noteModel.note ?? "N/A",
                  style: KTextStyle.textColorDark(20),
                ),
              ),
            ],
          ),
          if (noteModel.createdAt != null)
            Text(
                "Created: ${DateFormat("MM/dd hh:mma ").format(noteModel.createdAt!.toDate())}"),
          if (noteModel.updatedAt != null)
            Text(
                "Edit: ${DateFormat("MM/dd hh:mma ").format(noteModel.updatedAt!.toDate())}"),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KWidget.btnMedium(
                bgColor: KColors.dangerColor,
                color: KColors.white,
                title: "Delete",
                onTap: () {
                  noteModel.delete();
                },
              ),
              KWidget.btnMedium(
                bgColor: KColors.primaryColor,
                color: KColors.white,
                title: "Update",
                onTap: () {
                  showUpdateDialog(noteModel);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void createNewNote() async {
    var mNote = NoteModel(
      note: noteETC.text,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await mNote.create();
  }

  void showUpdateDialog(NoteModel noteModel) {
    var localNoteETC = TextEditingController(text: noteModel.note);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit your note"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                KTextField(
                  controller: localNoteETC,
                  dynamicHeight: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    noteModel.note = localNoteETC.text;
                    noteModel.update();
                   Get.back();
                    // hide keyboard
                    FocusScope.of(context).unfocus();
                  },
                  child: Text("Update")),
            ],
          );
        });
  }

  /* Future<List<String>> getData() async {
    print("Get Data Called");
    var notesData = await FirebaseFirestore.instance.collection("notes").get();

    List<String> myList = [];

    notesData.docs.forEach((element) {
      myList.add(element.data()['note']);
    });

    return myList;
  } */
}
