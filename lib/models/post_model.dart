import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String image;
  final String senderName;
  final String senderId;
  final String desctiption;
  final DateTime timestamp;
  final int likes;
  final String roomId;

  PostModel({
    required this.postId,
    required this.image,
    required this.senderName,
    required this.senderId,
    required this.desctiption,
    required this.timestamp,
    required this.likes,
    required this.roomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'image': image,
      'senderName': senderName,
      'senderId': senderId,
      'desctiption': desctiption,
      'timestamp': timestamp,
      'likes': likes,
      "roomId": roomId,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      roomId: map["roomId"] ?? "",
      postId: map['postId'] ?? '',
      image: map['image'] ?? '',
      senderName: map['senderName'] ?? '',
      senderId: map['senderId'] ?? '',
      desctiption: map['desctiption'] ?? '',
      timestamp:
          map['timestamp'] is DateTime
              ? map['timestamp']
              : (map['timestamp'] as Timestamp).toDate(),
      likes: map['likes'] ?? 0,
    );
  }
}
