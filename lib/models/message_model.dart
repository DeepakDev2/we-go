import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String message;
  final String senderName;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.message,
    required this.senderName,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map["senderId"] as String,
      message: map["message"] as String,
      senderName: map["senderName"] as String,
      timestamp: (map["timestamp"] as Timestamp).toDate(),
    );
  }
}
