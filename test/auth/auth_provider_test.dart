import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/provider/auth.dart';

//TODO adding tests
main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late Auth auth;

  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth(
      signedIn: false,
    );
    fireStore = FakeFirebaseFirestore();
    auth = Auth(fireStore: fireStore, firebaseAuth: mockFirebaseAuth);
  });

  tearDown(() {});

  group("Login", () {});

  group("Register", () {
    test("Tạo người dùng", () async {
      await auth.register("u1@gmail.com", "12345678", displayName: "User full name");
    });
  });
}
