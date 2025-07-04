import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_go/models/post_model.dart';
import 'package:we_go/screen/create_post_screen.dart';
import 'package:we_go/widgets/post_card.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<PostModel> posts = [];

  void updatePosts(List fetchedPostList) {
    posts.clear();
    for (int i = fetchedPostList.length - 1; i >= 0; i--) {
      posts.add(PostModel.fromMap(fetchedPostList[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CreatePostScreen(
                      roomId: widget.roomId,
                      onCreatePost: (BuildContext ctx) {
                        setState(() {
                          Navigator.of(ctx).pop();
                        });
                      },
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance
                .collection("posts")
                .doc(widget.roomId)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData == false ||
              snapshot.data == null ||
              snapshot.data!.exists == false) {
            return const Center(child: Text("No Post Yet!"));
          }
          updatePosts(snapshot.data!["posts"]);
          return ListView.builder(
            // reverse: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index], roomId: widget.roomId);
            },
          );
        },
      ),
    );
  }
}
