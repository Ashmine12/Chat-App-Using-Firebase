import 'package:chat_application/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseServices {
  Future<void> signUpWithEmailAndPassword(
      {required UserModel user, required String password}) async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user.email!, password: password);
    final firebase = FirebaseFirestore.instance.collection('user');
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await firebase.doc(uid).set(UserModel(
            uid: uid, name: user.name, email: user.email, image: user.image)
        .toJson());
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }
}
