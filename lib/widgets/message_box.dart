import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_go/models/message_model.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.isOwner, required this.message});
  final bool isOwner;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      decoration: BoxDecoration(
        color:
            isOwner
                ? const Color.fromARGB(144, 38, 150, 241)
                : const Color.fromARGB(175, 103, 100, 100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.senderName, style: TextStyle(color: Colors.lightGreen)),
          Text(message.message),
          Container(
            alignment: Alignment.centerRight,
            child: Text(DateFormat('hh:mm a').format(message.timestamp)),
          ),
        ],
      ),
    );
  }
}
