import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kurd_coders/src/constants/assets.dart';
import 'package:kurd_coders/src/models/post_model.dart';
import 'package:kurd_coders/src/post/post_view_screen.dart';
import 'package:kurd_coders/src/providers/app_provider.dart';
import 'package:kurd_coders/src/providers/auth_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppProvider? appProvider;
  AuthProvide? authProvider;

  @override
  Widget build(BuildContext context) {
    appProvider ??= Provider.of(context);
    authProvider ??= Provider.of(context);
    return Scaffold(
      backgroundColor: appProvider!.scafoldBackground,
      appBar: AppBar(
        title: Switch(
            value: Provider.of<AppProvider>(context).isDarkMood,
            onChanged: (value) {
              Provider.of<AppProvider>(context, listen: false)
                  .updateAppearance(value);
            }),
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: PostModel.streamAll(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return loadingListView;
          }
          print("Stream updated");
          List<PostModel> homePost = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 100,
              top: MediaQuery.of(context).padding.top,
            ),
            itemCount: homePost.length,
            itemBuilder: (context, index) {
              return cellType1(post: homePost[index]);
            },
          );
        },
      ),
    );
  }

  Widget get loadingListView => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 100,
          top: MediaQuery.of(context).padding.top,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return loadingCell();
        },
      );

  Widget cellType1({required PostModel post}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PostViewScreen(
              post: post,
            ));
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostViewScreen(
              post: post,
            ),
          ),
        ); */
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appProvider!.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              children: [
                Row(
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
                        Text(
                          "Azad Khorshed",
                          style: TextStyle(
                            fontSize: 15,
                            color: appProvider!.TextColor,
                          ),
                        ),
                        if (post.createdAt != null)
                          Text(
                            DateFormat('M/d hh:mma')
                                .format(post.createdAt!.toDate()),
                            style: TextStyle(
                              fontSize: 11,
                              color: appProvider!.TextColor1,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                ),
                const SizedBox(height: 10),
                if (post.imageUrl != null)
                  ClipRRect(
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
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 30,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LikeButton(
                    likeCount: post.likesUserUID?.length ?? 0,
                    isLiked: post.likesUserUID
                            ?.contains(authProvider!.myUser?.uid) ??
                        false,
                    onTap: (value) async {
                      /*  
                      if (value == false) {
                        post.updateLike(isAdd: true, userId: "1");
                      } else if (value == true) {
                        post.updateLike(isAdd: false, userId: "1");
                      } */

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
            ),
          ),
          Positioned(
            bottom: 0,
            left: 150,
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => PostViewScreen(
                    post: post,
                    isToOpenTheCOmment: true,
                  ),
                );
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostViewScreen(
                      post: post,
                      isToOpenTheCOmment: true,
                    ),
                  ),
                ) */
                ;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("posts")
                          .doc(post.uid)
                          .collection("comments")
                          .count()
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(),
                          );
                        }

                        var commentCounts = snapshot.data?.count ?? -1;

                        return Text(
                          "$commentCounts",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      Assets.resourceIconsIconComment,
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingCell() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(8),
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
          child: Column(
            children: [
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey.shade400,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: Image.asset(
                        Assets.resourceImagesPersone,
                        width: 40,
                        height: 40,
                      ).image,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          width: 130,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          width: 130,
                          height: 9,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          width: 130,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 30,
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey.shade400,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "0",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Image.asset(
                    Assets.resourceIconsIconLike,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 150,
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey.shade400,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "0",
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
          ),
        ),
      ],
    );
  }
}
