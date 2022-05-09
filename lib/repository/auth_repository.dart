import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sophia_hub/model/result_container.dart';

import 'base_repository.dart';

class AuthRepository with BaseRepository {
  late FirebaseAuth auth;
  late FirebaseStorage storage;
  late FirebaseFirestore firestore;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
  }) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.storage = storage ?? FirebaseStorage.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
  }

  Future<Result<User>> login(String email, pwd) async {
    try {
      UserCredential credential =
          await auth.signInWithEmailAndPassword(email: email, password: pwd);
      return Result(data: credential.user);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  Future<Result<bool>> signOut() async {
    try {
      await auth.signOut();
      return Result(data: true);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  Future<Result<User>> register(String email, pwd, displayName) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      await credential.user?.updateDisplayName(displayName);
      await credential.user?.sendEmailVerification();
      return Result(data: credential.user);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  Future updateAvatar(String filePath, String uid) async {
    try {
      String uid = this.auth.currentUser!.uid;

      File file = File(filePath);

      String fileName = "avatar${file.path.split('/').last.split(".").last}";
      final task =
          await storage.ref('users/$uid/avatar/$fileName').putFile(file);

      String imageUrl = await task.ref.getDownloadURL();

      //TODO checking later
      await auth.currentUser?.updatePhotoURL(imageUrl)
          //     .then((value)async {
          //   await firestore.collection("users").doc(uid).set({"avatarFileName": fileName});
          //   String currentAvatarFileName = (await firestore.collection("users").doc(uid).get()).get("avatarFileName");
          //   await storage.ref("users/$uid/avatar/$currentAvatarFileName").delete();
          // }).catchError((err){
          //   print("$err");
          // })
          ;
      return Result(data: "$imageUrl");
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  Future updateName(String name) async {
    try {
      await auth.currentUser?.updateDisplayName(name);
      return Result(data: name);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  void refresh({FirebaseAuth? firebaseAuth, FirebaseStorage? storage}) {
    this.auth = firebaseAuth ?? FirebaseAuth.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  Future resetPwd(String email) async {
    try {
      await  auth.sendPasswordResetEmail(email: email);
      return Result(data: "ok");
    } on Exception catch (e) {
      return Result(err: e);
    }
  }


  Future<Result<User>> signInWithGoogle(String name)async{
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );


      // Once signed in, return the UserCredential
      UserCredential cred = await auth.signInWithCredential(credential);
      await cred.user?.updateDisplayName(name);
      return Result(data: cred.user);
    } on Exception catch(e) {
      if(kDebugMode){
        debugPrint("Exception $e",);
      }
      return Result(err: e);
    }
  }
}
