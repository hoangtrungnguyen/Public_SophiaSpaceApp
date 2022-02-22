import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sophia_hub/model/result_container.dart';

import 'base_repository.dart';

class AuthRepository with BaseRepository {
  late FirebaseAuth auth;
  late FirebaseStorage storage;

  AuthRepository({FirebaseAuth? auth, FirebaseStorage? storage }) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.storage = storage ?? FirebaseStorage.instance;
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

  Future<Result<User>> register(String email, pwd,displayName) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      await credential.user?.updateDisplayName(displayName);
      return Result(data: credential.user);
    } on Exception catch (e) {
      return Result(err: e);
    }
  }

  Future updateAvatar(String filePath, String uid) async {
    try {

      File file = File(filePath);
      final task = await storage
          .ref('users/${this.auth.currentUser?.uid}/avatar/${file.path.split('/').last}')
          .putFile(file);

      String imageUrl = await task.ref.getDownloadURL();
      print("Image URL $imageUrl");
      if (kDebugMode || kProfileMode) {}
      await auth.currentUser?.updatePhotoURL(imageUrl);
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
}
