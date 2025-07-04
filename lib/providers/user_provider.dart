import 'package:flutter/material.dart';
import 'package:we_go/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  UserModel? getUser() {
    return userModel;
  }

  void updateUser(UserModel? user) {
    userModel = user;
    notifyListeners();
  }
}
