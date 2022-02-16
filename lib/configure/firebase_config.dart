import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {

  static Future config() async {
    // Debug mode use local firebase emulator
    if (kDebugMode) {

      FirebaseFirestore.instance.useFirestoreEmulator(dotenv.env['IP'] ?? "localhost" , 8080);

      await FirebaseAuth.instance.useAuthEmulator(dotenv.env['IP'] ?? "localhost", 9099);

      await FirebaseStorage.instance.useStorageEmulator(dotenv.env['IP'] ?? "localhost", 9199);

    } else if (kReleaseMode) {
    } else if (kProfileMode) {}
  }
}
