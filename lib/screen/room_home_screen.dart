import 'package:flutter/material.dart';
import 'package:we_go/screen/chat_screen.dart';
import 'package:we_go/screen/map_screen.dart';
import 'package:we_go/screen/post_screen.dart';

class RoomHomeScreen extends StatefulWidget {
  const RoomHomeScreen({super.key, required this.roomId});
  final String roomId;

  @override
  State<RoomHomeScreen> createState() => _RoomHomeScreenState();
}

class _RoomHomeScreenState extends State<RoomHomeScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final roomId = widget.roomId;
    final pageWidget = [
      ChatScreen(roomId: roomId),
      PostScreen(roomId: roomId),
      MapScreen(roomId: roomId),
    ];
    return Scaffold(
      body: pageWidget[_page],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: _page == 0 ? Colors.blueAccent : null,
            ),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
              color: _page == 1 ? Colors.blueAccent : null,
            ),
            label: "Images",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: _page == 2 ? Colors.blueAccent : null),
            label: "Map",
          ),
        ],
        onTap: (i) {
          setState(() {
            _page = i;
          });
        },
      ),
    );
  }
}
