import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:sophia_hub/provider/app_data.dart';

class UserData extends App {
  String? name;
  String? email;
  String? password;
  String? id;

  String? displayName;

  FirebaseAuth firebaseAuth;

  UserData(this.firebaseAuth);

  void clear() {
    name = '';
    email = '';
    password = '';
  }

  Future updateAvatar(String filePath, String uid) async {
    try {
      print("update $filePath");
      isLoadingPublisher.add(true);

      /// Heavy work load put inside an isolate stream

      File file = File(filePath);
      print("FIle name ${file.path.split('/').last}");
      final task = await firebase_storage.FirebaseStorage.instance
          .ref('avatars/${file.path.split('/').last}')
          .putFile(file);

      String imageUrl = await task.ref.getDownloadURL();
      print("Image URL $imageUrl");
      if (kDebugMode || kProfileMode) {}
      await firebaseAuth.currentUser?.updatePhotoURL(imageUrl);
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    } catch (e) {
      print("unknown $e");
    } finally {
      isLoadingPublisher.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future updateName(String name) async {
    await firebaseAuth.currentUser?.updateDisplayName(name);
  }
}
