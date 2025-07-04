import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_go/providers/user_provider.dart';
import 'package:we_go/screen/room_home_screen.dart';

class MyRoomList extends StatefulWidget {
  const MyRoomList({super.key});

  @override
  State<MyRoomList> createState() => _MyRoomListState();
}

class _MyRoomListState extends State<MyRoomList> {
  // List? rooms;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().userModel;
    final rooms = user!.rooms;
    const colors = [
      Color.fromRGBO(105, 183, 249, 1),
      Color.fromRGBO(0, 200, 190, 1),
      Color.fromRGBO(84, 107, 127, 1),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoomHomeScreen(roomId: rooms[index]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 40,
              decoration: BoxDecoration(
                color: colors[index % 3],
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rooms[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
