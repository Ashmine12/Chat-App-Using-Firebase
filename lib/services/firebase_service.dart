import 'package:chat_application/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseServices {
  Future<void> signUpWithEmailAndPassword({required UserModel user, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );

      final firebase = FirebaseFirestore.instance.collection('user');
      final uid = userCredential.user?.uid;

      if (uid != null) {
        await firebase.doc(uid).set(UserModel(
          uid: uid,
          name: user.name,
          email: user.email,
          image: user.image,
        ).toJson());
      } else {

      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }


  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      throw e;
    }
  }


  Future<List<UserModel>?> fetchUserData(String currentUserId) async {
    try {
      final firebase = FirebaseFirestore.instance.collection('user');

      final querySnapshot = await firebase.get();

      List<UserModel> userList = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Check if the user is not the current user
        if (doc.id != currentUserId) {
          final userModel = UserModel.fromJson(data);
          userList.add(userModel);
        }
      }

      return userList;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
