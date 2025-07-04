import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.senderName,
    required this.timestamp,
  });

  final String comment;
  final String senderName;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          // CircleAvatar(
          //   backgroundImage: NetworkImage(snap.data()['profilePic']),
          //   radius: 18,
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$senderName   ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
                          ),
                        ),
                        TextSpan(text: comment),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('hh:mm a').format(timestamp.toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite, size: 16),
          ),
        ],
      ),
    );
  }
}
