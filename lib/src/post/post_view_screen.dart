import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/helper/k_colors.dart';
import 'package:kurd_coders/src/helper/k_text_style.dart';
import 'package:kurd_coders/src/helper/k_widgets.dart';
import 'package:kurd_coders/src/models/comment_model.dart';
import 'package:kurd_coders/src/models/post_model.dart';
import 'package:kurd_coders/src/my_widgets/k_text_filed.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class PostViewScreen extends StatefulWidget {
  const PostViewScreen(
      {super.key, required this.post, this.isToOpenTheCOmment = false});

  final PostModel post;
  final bool isToOpenTheCOmment;

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  var commentETC = TextEditingController();
  var focusNode = FocusNode();

  AuthProvide? authProvider;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.isToOpenTheCOmment) {
      Future.delayed(const Duration(milliseconds: 50), () {
        focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider ??= Provider.of<AuthProvide>(context);
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  get _appBar => AppBar(
        title: const Text('Post View'),
      );

  get _body => SingleChildScrollView(
        controller: scrollController,
        child: StreamBuilder<PostModel>(
          stream: PostModel.streamOne(widget.post.uid),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: KWidget.loadingView(true),
              );
            }
            var postModel = snapshot.data!;

            return Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                postOwner(postModel),
                const SizedBox(height: 10),
                postText(postModel),
                const SizedBox(height: 10),
                if (widget.post.imageUrl != null) postImage(postModel),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    likeWidget(postModel),
                    const SizedBox(
                      width: 16,
                    ),
                    commentWidget(postModel)
                  ],
                ),
                commentSection(postModel),
                const SizedBox(
                  height: 50,
                )
              ],
            );
          },
        ),
      );

  Widget commentWidget(PostModel post) {
    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withAlpha(100),
              offset: Offset(2, 4),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "nine",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 4),
            Image.asset(
              Assets.resourceIconsIconComment,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget postImage(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: CachedNetworkImage(
          imageUrl: post.imageUrl!,
          width: double.infinity,
          fit: BoxFit.contain,
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.shade400,
              child: Container(
                width: double.infinity,
                height: 350,
                color: Colors.red,
              ),
            );
          },
          errorWidget: (context, url, error) {
            return const Text("Image Not available");
          },
        ),
      ),
    );
  }

  Padding postText(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          Expanded(
            child: Text(
              post.text ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget postOwner(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: Image.asset(
              Assets.resourceImagesPersone,
              width: 40,
              height: 40,
            ).image,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Azad Khorshed",
                style: TextStyle(fontSize: 15),
              ),
              if (widget.post.createdAt != null)
                Text(
                  DateFormat('M/d hh:mma')
                      .format(widget.post.createdAt!.toDate()),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
            ],
          )
        ],
      ),
    );
  }

  Container likeWidget(PostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withAlpha(100),
            offset: const Offset(2, 4),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LikeButton(
            likeCount: post.likesUserUID?.length ?? 0,
            isLiked:
                post.likesUserUID?.contains(authProvider!.myUser?.uid) ?? false,
            onTap: (value) async {
              if (authProvider!.myUser != null) {
                post.updateLike(
                    userId: authProvider!.myUser!.uid!, isAdd: !value);
                return !value;
              }
              return value;
            },
          ),
        ],
      ),
    );
  }

  Widget commentSection(PostModel post) {
    return StreamBuilder<List<CommentModel>>(
      stream: post.streamAllComments(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        var comments = snapshot.data!;

        return Column(
          children: [
            SizedBox(
              height: 16,
            ),
            KTextField(
              focusNode: focusNode,
              controller: commentETC,
              hint: "Write a comment",
              dynamicHeight: true,
              suffixIcon: IconButton(
                  onPressed: () => postComment(post), icon: Icon(Icons.send)),
            ),

            // for (var i = 0; i < (widget.post.comments?.length ?? 0); i++)
            //   commentCell(widget.post.comments![i]),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (conetxt, index) {
                return commentCell(comments[index], post);
              },
            )
          ],
        );
      },
    );
  }

  Widget commentCell(CommentModel comment, PostModel post) {
    return GestureDetector(
      onLongPress: () {
        if (comment.userUid == "1") {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Delete your Comment"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        comment.delete(post.uid!);
                        Get.back();
                      },
                      child: Text("Delete"),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                );
              });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: KColors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withAlpha(100),
              offset: Offset(2, 4),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: Image.asset(
                Assets.resourceImagesPersone,
                width: 40,
                height: 40,
              ).image,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.comment ?? "",
                    style: KTextStyle.textColorDark(18),
                  ),
                  if (comment.createdAt != null)
                    Text(
                      DateFormat('M/d hh:mma')
                          .format(comment.createdAt!.toDate()),
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  postComment(PostModel post) {
    var comment = commentETC.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please write a comment"),
        backgroundColor: KColors.dangerColor,
      ));
      return;
    }

    var cCommment = CommentModel(
      uid: Uuid().v4(),
      comment: comment,
      userUid: "1",
      createdAt: Timestamp.now(),
    );

    post.addComment(comment: cCommment);

    FocusManager.instance.primaryFocus?.unfocus();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Comment Sent"),
      backgroundColor: KColors.successColor,
    ));

    commentETC.clear();

    // scroll to the bottom of the screen
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
      );
    });
  }
}
