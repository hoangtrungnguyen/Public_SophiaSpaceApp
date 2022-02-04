import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sophia_hub/constant/firebase.dart';
import 'package:sophia_hub/model/quote.dart';

class FirebaseConfig {
  static Future useEmulator() async {}

  static Future config() async {
    // Debug mode use local firebase emulator
    if (kDebugMode) {
      //Thay host thành ip của máy tính và kết nối wifi cả điện thoại và máy tính
      //TODO [Firestore | <pc_ip>:8080]
      FirebaseFirestore.instance.useFirestoreEmulator("172.16.0.241", 8080);
      //TODO [Authentication | <pc_ip>:9099]

      await FirebaseAuth.instance.useAuthEmulator('172.16.0.241', 9099);

      //TODO: Thêm dữ liệu quote cho Firestore Emulators ở đây
      // Ideal time to initialize
      /// TODO Not yet understanding why can not upload image to firebase emulator so dev should review this line of code
      await FirebaseStorage.instance.useStorageEmulator('172.16.0.241', 9199);

      Future.forEach([0, 1, 2], (_) async {
        final snapshots = await FirebaseFirestore.instance
            .collection(FirebaseKey.quotes)
            .get();
        if (snapshots.docs.length > 3) return;
        Quote quote = Quote(
            imageUrl:
                "https://images.unsplash.com/photo-1567626143573-dfee80dddb2c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8",
            content:
                "Ai cũng nghĩ muốn thay đổi thế giới nhưng không ai nghĩ đến việc thay đổi bản thân")
          ..authorName = "Leo Tolstoy";
        await FirebaseFirestore.instance
            .collection(FirebaseKey.quotes)
            .add(quote.toJson());
      });
    } else if (kReleaseMode) {
    } else if (kProfileMode) {}
  }
}
