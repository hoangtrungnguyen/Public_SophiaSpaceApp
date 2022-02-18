import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/repository/auth_repository.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';

//TODO adding tests
main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fireStore;
  late AccountViewModel viewModel;
  late MockFirebaseStorage firebaseStorage;
  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth(
      signedIn: false,
    );
    firebaseStorage = MockFirebaseStorage();
    fireStore = FakeFirebaseFirestore();
    viewModel = AccountViewModel(
      repository:  AuthRepository(auth: mockFirebaseAuth)
    );
  });

  tearDown(() {});

  group("Login", () {});

  group("Register", () {
    test("Tạo người dùng", () async {
      await viewModel.register("u1@gmail.com", "12345678", "User full name");
    });
  });
}
