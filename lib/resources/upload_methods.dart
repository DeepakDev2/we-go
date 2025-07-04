import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_go/models/message_model.dart';
import 'package:we_go/models/post_model.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class UploadMethods {
  Future<void> addChat(
    MessageModel message,
    BuildContext context,
    String roomId,
  ) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection("chats").doc(roomId).set({
        "chats": FieldValue.arrayUnion([
          {
            "message": message.message,
            "senderId": message.senderId,
            "senderName": message.senderName,
            "timestamp": message.timestamp,
          },
        ]),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      showSnackBar(context, e.code);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String> uploadPost(PostModel post) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection("posts").doc(post.roomId).set({
        "posts": FieldValue.arrayUnion([post.toMap()]),
      }, SetOptions(merge: true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<PostModel>> fetchPost({required String roomId}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final snapshot =
          await firestoreInstance.collection("posts").doc(roomId).get();
      if (snapshot.exists == false || snapshot.data() == null) {
        return [];
      }
      final List list = (snapshot.data()!)["posts"];
      List<PostModel> posts = [];
      for (int i = 0; i < list.length; i++) {
        posts.add(PostModel.fromMap(list[i]));
      }
      return posts;
    } catch (e) {
      return [];
    }
  }

  Future<String> likeAPost({
    required String postId,
    required String userId,
    required String roomId,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance
          .collection("posts")
          .doc(roomId)
          .collection("likes")
          .doc(postId)
          .set({
            "likes": FieldValue.arrayUnion([userId]),
          }, SetOptions(merge: true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> unlikeAPost({
    required String postId,
    required String userId,
    required String roomId,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance
          .collection("posts")
          .doc(roomId)
          .collection("likes")
          .doc(postId)
          .set({
            "likes": FieldValue.arrayRemove([userId]),
          }, SetOptions(merge: true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> postComment({
    required String comment,
    required String roomId,
    required String postId,
    required String senderName,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance
          .collection("posts")
          .doc(roomId)
          .collection("comments")
          .doc(postId)
          .set({
            "comments": FieldValue.arrayUnion([
              {
                "comment": comment,
                "sender": senderName,
                "timestamp": DateTime.now(),
              },
            ]),
          }, SetOptions(merge: true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }
}
