// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
//
//
// main() async {
//   // Mock sign in with Google.
//   final googleSignIn = MockGoogleSignIn();
//   final signinAccount = await googleSignIn.signIn();
//   final googleAuth = await signinAccount.authentication;
//   final AuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//   // Sign in.
//   final userSignInData = MockUser(
//     isAnonymous: false,
//     uid: 'someuid',
//     email: 'bob@somedomain.com',
//     displayName: 'Bob',
//   );
//   final auth = MockFirebaseAuth(mockUser: userSignInData);
//   final result = await auth.signInWithCredential(credential);
//   final user = await result.user;
//   print(user.displayName);
// }
