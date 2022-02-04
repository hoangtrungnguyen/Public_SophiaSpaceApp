import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/provider/auth.dart';

//TODO adding tests
main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late Auth auth;
  late MockFirebaseStorage firebaseStorage;
  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth(
      signedIn: false,
    );
    firebaseStorage = MockFirebaseStorage();
    fireStore = FakeFirebaseFirestore();
    auth = Auth(
        fireStore: fireStore,
        firebaseAuth: mockFirebaseAuth,
        firebaseStorage: firebaseStorage);
  });

  tearDown(() {});

  group("Login", () {});

  group("Register", () {
    test("Tạo người dùng", () async {
      await auth.register("u1@gmail.com", "12345678", displayName: "User full name");
    });
  });
}
