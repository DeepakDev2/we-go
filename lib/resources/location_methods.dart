import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationMethods {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;
  void updateLocation({required double lat, required double lng}) {
    try {
      firestore.collection("location").doc(userId).set({
        "lat": lat,
        "lng": lng,
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
