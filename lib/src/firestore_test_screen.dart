import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kurd_coders/src/helper/k_text_style.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => FirebaseeTestScreenState();
}

class FirebaseeTestScreenState extends State<FirebaseTestScreen> {
  var idController = TextEditingController();
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var jobController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          _body,
          KWidget.loadingView(true, text: "Loading.."),
        ],
      ),
    );
  }

  Widget get _body => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            KTextField(
              controller: idController,
              title: "ID",
            ),
            KTextField(
              controller: nameController,
              title: "Name",
            ),
            KTextField(
              controller: jobController,
              title: "Job",
            ),
            KTextField(
              controller: ageController,
              title: "Age",
            ),
            SizedBox(height: 20),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc("1")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }

                  var myDoc = snapshot.data!;

                  var myData = myDoc.data();

                  String? name = myData?["name"];
                  String? job = myData?["job"];

                  int? age = int.tryParse(myData?['age'].toString() ?? "");

                  return Column(
                    children: [
                      Text("Name: $name", style: KTextStyle.textColorDark(24)),
                      Text(
                        "JOb: $job",
                        style: KTextStyle.textColorDark(24),
                      ),
                      Text(
                        "Age: $age",
                        style: KTextStyle.textColorDark(24),
                      ),
                    ],
                  );
                }),
            SizedBox(height: 20),
            KWidget.btnMedium(
                title: "Read",
                onTap: () {
                  read();
                }),
            SizedBox(height: 20),
            KWidget.btnMedium(
                title: "create",
                onTap: () {
                  create();
                }),
            SizedBox(height: 20),
            KWidget.btnMedium(
                title: "update",
                onTap: () {
                  update();
                }),
            SizedBox(height: 20),
            KWidget.btnMedium(
                title: "delete",
                onTap: () {
                  delete();
                }),
            SizedBox(height: 20),
          ],
        ),
      );

  void create() async {
    setState(() {
      isLoading = true;
    });
    var age = int.tryParse(ageController.text);

    if (age == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("The age is required? Ex: 25"),
      ));
    }

    await FirebaseFirestore.instance.collection("user").doc().set({
      "name": nameController.text,
      "job": jobController.text,
      "age": age,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("saved"),
    ));
    setState(() {
      isLoading = false;
    });
  }

  void update() async {
    setState(() {
      isLoading = true;
    });
    var age = int.tryParse(ageController.text);
    await FirebaseFirestore.instance
        .collection("user")
        .doc(idController.text)
        .update({
      "name": nameController.text,
      "job": jobController.text,
      "age": age,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("updated"),
    ));
    setState(() {
      isLoading = false;
    });
  }

  void delete() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("user")
        .doc(idController.text)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Deleted"),
    ));
    setState(() {
      isLoading = false;
    });
  }

  void read() async {
    setState(() {
      isLoading = true;
    });
    var myDoc =
        await FirebaseFirestore.instance.collection("user").doc("1").get();

    print("doc id: ${myDoc.id}");
    print("is exists: ${myDoc.exists}");
    print("doc data: ${myDoc.data()}");

    if (myDoc.data() != null) {
      Map<String, dynamic> data = myDoc.data()!;

      String? name = data["name"];
      String? job = data["job"];
      int? age = int.tryParse(data['age'].toString());

      nameController.text = name ?? "N/A";
      jobController.text = job ?? "N/A";
      ageController.text = age?.toString() ?? "N/A";
    }

    setState(() {
      isLoading = false;
    });
  }
}
