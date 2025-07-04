import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_go/models/message_model.dart';
import 'package:we_go/models/user_model.dart';
import 'package:we_go/providers/user_provider.dart';
import 'package:we_go/resources/upload_methods.dart';
import 'package:we_go/widgets/custom_text_input_box.dart';
import 'package:we_go/widgets/message_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.roomId});
  final String roomId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();

  UserModel? user;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  void addChat() async {
    final message = MessageModel(
      senderId: userId,
      message: chatController.text,
      senderName: user!.name,
      timestamp: DateTime.now(),
    );
    chatController.text = "";
    await UploadMethods().addChat(message, context, widget.roomId);
  }

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatStream() {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.roomId)
        .snapshots();
  }

  List<MessageModel> messages = [];
  void prepareMessage(Map<String, dynamic> messageList) {
    List list = messageList["chats"] as List;
    messages.clear();
    for (int i = list.length - 1; i >= 0; i--) {
      final message = MessageModel.fromMap(list[i]);
      messages.add(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).getUser();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              // width: 200,
              height: double.infinity,
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: getChatStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData == false ||
                      snapshot.data == null ||
                      snapshot.data!.data() == null) {
                    return Center(child: Text("No messages yet"));
                  }
                  prepareMessage(snapshot.data!.data()!);
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBox(
                        isOwner: (messages[index].senderId == userId),
                        message: messages[index],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextInputBox(chatController: chatController),
              ),
              IconButton(onPressed: addChat, icon: Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
