import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/firebase_options.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/provider/task_provider.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';
import 'package:sophia_hub/view/page/note/create_note_page.dart';
import 'package:sophia_hub/view/page/note/note_detail.dart';
import 'package:sophia_hub/view/page/task/create_task_page.dart';
import 'package:sophia_hub/view/page/task/list_task_page.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => print(value));

  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Configure App Small Habits
    MaterialApp app = MaterialApp(
      title: 'Small Habits',
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AuthPage.nameRoute
          : BaseContainer.nameRoute,
      onUnknownRoute: (setting) => MaterialPageRoute(
          builder: (_) => Center(child: Text("Không thể tìm thấy trang này"))),
      onGenerateRoute: (settings) {
        //Read more in the link below
        // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
        Widget widget = Container();
        switch (settings.name) {
          case AuthPage.nameRoute:
            widget = AuthPage();
            break;
          case BaseContainer.nameRoute:
            widget = BaseContainer();
            break;
          case CreateNotePage.nameRoute:
            // Cast the arguments to the correct
            // type: Note.
            widget = CreateNotePage();
            break;
          case NoteDetails.nameRoute:
            // Cast the arguments to the correct
            // type: Note.
            try {
              Note note = settings.arguments as Note;
              widget = NoteDetails.view(note);
            } catch (e) {
              print("Phải có object Note");
            }
            break;
          case CreateTaskPage.nameRoute:
            widget = CreateTaskPage();
            break;
          case ListTaskPage.nameRoute:
            widget = ListTaskPage();
            break;
          default:
            // The assertion here will help remind
            // us of that higher up in the call stack, since
            // this assertion would otherwise fire somewhere
            // in the framework.
            assert(false, 'Need to implement ${settings.name}');
        }

        // MaterialPageRoute route = MaterialPageRoute(
        //
        //   builder: builder,
        // );
        return RouteAnimation.buildDefaultRouteTransition(widget, settings);
      },
      theme: lightTheme(context),
      darkTheme: lightTheme(context),
    );

    // Providers cần thiết.
    MultiProvider multiProvider = MultiProvider(providers: [
      StreamProvider<firebase_auth.User?>(
        create: (_) => FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        updateShouldNotify: (pre, cur) => true,
      ),

      //UserProvider quan hệ phụ thuộc với firebase_auth.User
      // ProxyPrivider sẽ được thay đổi lại mỗi khi firbase_auth.User thay đổi.
      ChangeNotifierProxyProvider<firebase_auth.User?, Auth>(
        create: (_) => Auth(
            firebaseAuth: FirebaseAuth.instance,
            fireStore: FirebaseFirestore.instance),
        update: (BuildContext context, firebaseUser, Auth? previous) {
          // print("updating Auth ${firebaseUser?.uid}");
          previous?.refresh();
          return previous!;
        },
      ),

      ChangeNotifierProxyProvider<Auth, NotesProvider>(
        create: (_) => NotesProvider(
            uid: FirebaseAuth.instance.currentUser?.uid ?? 'NaN',
            fireStore: FirebaseFirestore.instance),
        lazy: true,
        update: (_, auth, preNotesProvider) {
          //TODO logic thay doi du lieu moi khi thay doi tai khoan nguoi dung
          if (auth.firebaseAuth.currentUser == null) preNotesProvider?.clear();
          print("updating notes Data ${auth.firebaseAuth.currentUser?.uid}");

          return preNotesProvider!;
        },
      ),
      ChangeNotifierProxyProvider<Auth, TaskProvider>(
        create: (_) => TaskProvider(),
        lazy: true,
        update: (_, userProvider, preTaskProvider) {
          // print("updating notes task provider");
          return preTaskProvider!;
        },
      ),
    ], child: app);

    Future.microtask(() {
      FirebaseAuth.instance
          .authStateChanges()
          .listen((firebase_auth.User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
    });
    return multiProvider;
  }
}
