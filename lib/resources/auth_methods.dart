import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_go/models/user_model.dart';
import 'package:we_go/providers/user_provider.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class AuthMethods {
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final authInstance = FirebaseAuth.instance;
      final cred = await authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user == null) {
        return "Fail";
      }
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signIn(String email, String password, String name) async {
    String res = "Success";
    try {
      final firebaseInstance = FirebaseAuth.instance;
      final cred = await firebaseInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection("users").doc(cred.user!.uid).set({
        "email": email,
        "name": name,
        "rooms": [],
        "myRooms": [],
      });

      return res;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> getUser(BuildContext context) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final snapshot =
          await firestoreInstance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      final user = UserModel.fromMap(snapshot.data()!);
      context.read<UserProvider>().updateUser(user);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
