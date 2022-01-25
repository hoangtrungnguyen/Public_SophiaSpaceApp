import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/model/user.dart';
import 'package:sophia_hub/provider/app_data.dart';

class Auth extends App {
  UserData user = UserData();
  FirebaseFirestore fireStore;
  FirebaseAuth firebaseAuth;

  Auth({required this.fireStore, required this.firebaseAuth}) {
    Future.microtask(() async {
//    FirebaseAuth auth = await FirebaseAuth.instance.currentUser;
    });
  }

  Future<Result<UserCredential>> register(String email, String pwd,
      {String? displayName}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pwd);

      // Create a CollectionReference called users that references the firestore collection
      CollectionReference users = fireStore.collection('users');
      // Call the user's CollectionReference to add a new user
      await users
          .doc(userCredential.user!.uid)
          .set({"display_name": displayName, 'email': email});
      print("User Added");

      return Result<UserCredential>(data: userCredential, err: null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return Result(err: e, data: null);
    } on Exception catch (e) {
      return Result(err: e, data: null);
    } catch (e) {
      print("unkown");
      return Result(err: Exception("Unknown Exception"), data: null);
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
    } on Exception catch (e) {
      return Result(err: e, data: null);
    } catch (e) {
      print("unkown");
      return Result(err: Exception("Unknown Exception"), data: null);
    }
  }

  Future<Result<bool>> logOut() async {
    try {
      await firebaseAuth.signOut();
      return Result(data: true, err: null);
    } on Exception catch (e) {
      return Result(data: null, err: e);
    }
  }

  void refresh() {
    //TODO refresh on device user data
    notifyListeners();
  }
}
