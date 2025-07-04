import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_go/models/post_model.dart';
import 'package:we_go/models/user_model.dart';
import 'package:we_go/providers/user_provider.dart';
import 'package:we_go/resources/upload_methods.dart';
import 'package:we_go/widgets/comment_card.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;
  const CommentsScreen({super.key, required this.post});

  @override
  CommentsScreenState createState() => CommentsScreenState();
}

class CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void postComment() async {
    try {
      String res = await UploadMethods().postComment(
        comment: commentEditingController.text,
        postId: widget.post.postId,
        roomId: widget.post.roomId,
        senderName: context.read<UserProvider>().getUser()!.name,
      );

      if (res != 'Success') {
        if (context.mounted) showSnackBar(context, res);
      }
      commentEditingController.text = "";
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Comments'), centerTitle: false),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.post.roomId)
                .collection("comments")
                .doc(widget.post.postId)
                .snapshots(),
        builder: (
          context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null ||
              snapshot.data!.exists == false ||
              snapshot.data!.data() == null) {
            return const Center(child: Text("No comment yet!"));
          }

          return ListView.builder(
            // reverse: true,
            controller: _scrollController,
            itemCount: (snapshot.data!.data())!["comments"].length,
            itemBuilder: (ctx, index) {
              final message = snapshot.data!.data()!["comments"][index];
              return CommentCard(
                comment: message["comment"],
                senderName: message["sender"],
                timestamp: message["timestamp"],
              );
            },
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              // CircleAvatar(
              //   backgroundImage: NetworkImage(user.photoUrl),
              //   radius: 18,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.name}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
