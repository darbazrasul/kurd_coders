import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_helper.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/models/post_model.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';
import 'package:uuid/uuid.dart';

class AddNewPostScreen extends StatefulWidget {
  const AddNewPostScreen({super.key});

  @override
  State<AddNewPostScreen> createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  File? myImageFile;
  var textController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _bodyLayout,
    );
  }

  get _bodyLayout => Stack(
        children: [_body, KWidget.loadingView(isLoading)],
      );

  get _body => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            KTextField(
              controller: textController,
              hint: "Paragraph",
              title: "Paragraph",
              dynamicHeight: true,
            ),
            GestureDetector(
              onTap: () {
                selectimage();
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: KColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: postImageWidget(),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  selectimage();
                },
                child: Text("Add image")),
            ElevatedButton(
                onPressed: () {
                  publishThePost();
                },
                child: Text("Publish")),
          ],
        ),
      );

  void selectimage() async {
    myImageFile = await KHelper.pickImageFromGallery(cropTheImage: true);
    setState(() {});
  }

  void publishThePost() async {
    // check for fields
    if (textController.text.trim().isEmpty && myImageFile == null) {
      // PLease type a test or add an image
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please type a test or add an image")));
    }

    setState(() {
      isLoading = true;
    });

    // upload Media
    String? uploadLink;
    if (myImageFile != null) {
      uploadLink = await uploadMedia(myImageFile!);
      if (uploadLink == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    // create Model
    var post = PostModel(
      imageUrl: uploadLink,
      text: textController.text.trim(),
      userUid: "1",
    );

    // publish the Post Model
    await post.create();

    setState(() {
      isLoading = false;
    });

    Get.back();
  }

  Widget postImageWidget() {
    if (myImageFile == null) {
      return Image.asset(
        Assets.resourceIconsAddImage,
      );
    } else {
      return Image.file(myImageFile!);
    }
  }

  Future<String?> uploadMedia(File myImageFile) async {
    var ref = FirebaseStorage.instance.ref().child("post-images");

    var uploadFileName = "${Uuid().v4()}.png";
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
