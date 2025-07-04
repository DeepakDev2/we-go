import 'package:cloud_firestore/cloud_firestore.dart';

class RoomMethods {
  Future<String> createRoom({
    required String roomId,
    required String roomPassword,
    required String uid,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final docRef = firestoreInstance.collection("room").doc(roomId);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        return "Room with similar id already exist.";
      }
      docRef.set({
        "roomId": roomId,
        "password": roomPassword,
        "members": [],
        "ownerId": uid,
      });
      return "Success";
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> validateRoomCred({
    required String roomId,
    required String roomPassword,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final docRef = firestoreInstance.collection("room").doc(roomId);
      final snapshot = await docRef.get();
      if (snapshot.exists == false) {
        return "Incorrect room ID";
      }
      if (((snapshot.data() as Map<String, dynamic>)["password"] as String) ==
          roomPassword) {
        return "Success";
      } else {
        return "Incorrect password";
      }
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addUserInRoom({
    required String roomId,
    required String uid,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final docRef = firestoreInstance.collection("room").doc(roomId);
      await docRef.set({
        "members": FieldValue.arrayUnion([uid]),
      }, SetOptions(merge: true));
      firestoreInstance.collection("users").doc(uid).set({
        "rooms": FieldValue.arrayUnion([roomId]),
      }, SetOptions(merge: true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List> getMembersList({required String roomId}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final roomInfo =
          await firestoreInstance.collection("room").doc(roomId).get();
      return roomInfo["members"] as List;
    } on FirebaseException catch (e) {
      return [e.toString()];
    } catch (e) {
      return [e.toString()];
    }
  }

  // Future<String> likePost(Stirng roomId,String postId)
}
