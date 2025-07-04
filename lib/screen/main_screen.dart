import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_go/models/user_model.dart';
import 'package:we_go/pages/create_room.dart';
import 'package:we_go/pages/join_room.dart';
import 'package:we_go/providers/user_provider.dart';
import 'package:we_go/resources/auth_methods.dart';
import 'package:we_go/pages/my_room_list.dart';

enum ActiveScreen { createRoom, myRoomList, joinRoom }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserModel? user;

  ActiveScreen activeScreen = ActiveScreen.myRoomList;

  void updateUser() async {
    await AuthMethods().getUser(context);
    setState(() {
      user = Provider.of<UserProvider>(context, listen: false).getUser();
    });
  }

  @override
  void initState() {
    super.initState();
    updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
          appBar: AppBar(title: Text("We Go")),

          drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('My Rooms'),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          activeScreen = ActiveScreen.myRoomList;
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Create Room'),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          activeScreen = ActiveScreen.createRoom;
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Join Room'),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          activeScreen = ActiveScreen.joinRoom;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body:
              activeScreen == ActiveScreen.myRoomList
                  ? MyRoomList()
                  : activeScreen == ActiveScreen.createRoom
                  ? CreateRoom(
                    onCreateRoom: () {
                      setState(() {
                        activeScreen = ActiveScreen.myRoomList;
                      });
                    },
                  )
                  : JoinRoom(
                    onJoinRoom: () {
                      setState(() {
                        activeScreen = ActiveScreen.myRoomList;
                      });
                    },
                  ),
        );
  }
}
