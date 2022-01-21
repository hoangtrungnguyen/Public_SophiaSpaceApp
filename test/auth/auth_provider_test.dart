import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;

  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth(
      signedIn: false,
    );
    fireStore = FakeFirebaseFirestore();
  });

  tearDown(() {});

  group("Login", () {});

  group("Register", () {
    test("Tạo người dùng", () async {
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: "u1@gmail.com", password: "12345678");
    });
  });
}
