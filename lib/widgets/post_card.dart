import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_go/models/post_model.dart';
import 'package:we_go/resources/upload_methods.dart';
import 'package:we_go/screen/comment_screen.dart';
import 'package:we_go/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post, required this.roomId});
  final String roomId;

  final PostModel post;
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    userId = FirebaseAuth.instance.currentUser!.uid;
    isLikedPost();
  }

  bool isLiked = false;
  String? userId;

  void isLikedPost() async {
    final res =
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.roomId)
            .collection("likes")
            .doc(widget.post.postId)
            .get();
    isLiked = (res["likes"] as List).contains(userId);
    likeCount = (res["likes"] as List).length;
    setState(() {});
  }

  void changelikeState(String userId) async {
    if (isLiked) {
      await UploadMethods().unlikeAPost(
        userId: userId,
        roomId: widget.roomId,
        postId: widget.post.postId,
      );
    } else {
      await UploadMethods().likeAPost(
        userId: userId,
        roomId: widget.roomId,
        postId: widget.post.postId,
      );
    }
    if (isLiked) {
      likeCount--;
    } else {
      likeCount++;
    }
    isLiked = !isLiked;
    setState(() {});
  }

  void fetchCommentLen() async {
    // try {
    //   QuerySnapshot snap =
    //       await FirebaseFirestore.instance
    //           .collection('posts')
    //           .doc(widget.snap['postId'])
    //           .collection('comments')
    //           .get();
    //   commentLen = snap.docs.length;
    // } catch (err) {
    //   showSnackBar(context, err.toString());
    // }
    // setState(() {});
  }

  void deletePost(String postId) async {
    // try {
    //   await FireStoreMethods().deletePost(postId);
    // } catch (err) {
    //   showSnackBar(context, err.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                // CircleAvatar(
                //   radius: 16,
                //   backgroundImage: NetworkImage(
                //     widget.snap['profImage'].toString(),
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.post.senderName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              if (isLiked == false) {
                changelikeState(userId!);
              }
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(widget.post.image, fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: isLiked,
                smallLike: true,
                child: IconButton(
                  icon:
                      isLiked
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                  onPressed: () {
                    changelikeState(userId!);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CommentsScreen(post: widget.post);
                    },
                  );
                },
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: () {}),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '$likeCount likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: widget.post.senderName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${widget.post.desctiption}'),
                      ],
                    ),
                  ),
                ),
                // InkWell(
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 4),
                //     child: Text(
                //       'View all comments',
                //       style: const TextStyle(fontSize: 16, color: Colors.grey),
                //     ),
                //   ),
                //   onTap: () {
                //     showModalBottomSheet(
                //       context: context,
                //       builder: (context) {
                //         return CommentsScreen(post: widget.post);
                //       },
                //     );
                //   },
                // ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.post.timestamp),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
