import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_go/resources/auth_methods.dart';
import 'package:we_go/resources/room_methods.dart';
import 'package:we_go/widgets/custom_button.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key, required this.onCreateRoom});

  final VoidCallback onCreateRoom;

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _roomPasswordController = TextEditingController();

  void createNewRoom() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final res = await RoomMethods().createRoom(
      roomId: _roomIdController.text,
      roomPassword: _roomPasswordController.text,
      uid: uid,
    );
    if (context.mounted) {
      if (res != "Success") {
        showSnackBar(context, "Some error occured");
        return;
      }
      showSnackBar(context, "Room Created!");
      await RoomMethods().addUserInRoom(
        roomId: _roomIdController.text,
        uid: uid,
      );
      await AuthMethods().getUser(context);
      widget.onCreateRoom();
    }
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    _roomPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _roomIdController,
            decoration: InputDecoration(
              hintText: "Room ID",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 10),
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _roomPasswordController,
            decoration: InputDecoration(
              hintText: "Room Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 10),
              ),
            ),
          ),
          const SizedBox(height: 40),
          CustomButton(onClick: createNewRoom, text: "Create Room"),
        ],
      ),
    );
  }
}
