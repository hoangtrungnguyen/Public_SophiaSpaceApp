import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/model/user.dart';

class UserProvider extends ChangeNotifier {
  UserData user = UserData();

  UserProvider() {
    Future.microtask(() async {
//    FirebaseAuth auth = await FirebaseAuth.instance.currentUser;
    });
  }

  Future<Result<UserCredential>> register(String email, String pwd,
      {String displayName}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);

      // Create a CollectionReference called users that references the firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      users
          .doc(userCredential.user.uid)
          .set({"display_name" : displayName})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      return Result<UserCredential>(data: userCredential, err: null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return Result(err: e, data: null);
    } catch (e) {
      return Result(err: e, data: null);
      ;
    }
  }

  Future<Result<UserCredential>> login(String email, pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      return Result<UserCredential>(data: userCredential, err: null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return Result(err: e, data: null);
    } catch (e) {
      return Result(err: e, data: null);
    }
  }

  Future<Result<bool>> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Result(data: true, err: null);
    } catch (e) {
      return Result(data: null, err: e);
    }
  }
}
