import 'package:flutter/material.dart';

class CustomTextInputBox extends StatelessWidget {
  const CustomTextInputBox({
    super.key,
    required this.chatController,
    this.hintText = "Message",
  });
  final TextEditingController chatController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(175, 103, 100, 100),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: chatController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        maxLines: null, // Auto-grow

        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
