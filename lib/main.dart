import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/configure/firebase_config.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/firebase_options.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/notes_provider.dart';
import 'package:sophia_hub/provider/quote_provider.dart';
import 'package:sophia_hub/provider/share_pref.dart';
import 'package:sophia_hub/provider/task_provider.dart';
import 'package:sophia_hub/provider/ui_logic.dart';
import 'package:sophia_hub/provider/user_provider.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/account/account_page.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';
import 'package:sophia_hub/view/page/note/create_note_page.dart';
import 'package:sophia_hub/view/page/note/note_detail.dart';
import 'package:sophia_hub/view/page/task/create_task_page.dart';
import 'package:sophia_hub/view/page/task/list_task_page.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    ).then((value) =>
        print("$value"));


    await FirebaseConfig.config();
     SharePref sharePref = SharePref();
     await sharePref.init();

    runApp(MyApp(sharePref));
  }, (Object error, StackTrace stack) {
    // myBackend.sendError(error, stack);
    print("Send error's info to server: ${error} with stack $stack");
  });
}


class MyApp extends StatelessWidget {

  SharePref? sharePref;

  MyApp(SharePref sharePref){
    this.sharePref = sharePref;
  }

  @override
  Widget build(BuildContext context) {
    //Configure App Small Habits
    Widget app = Consumer<SharePref>(
      builder: (context,sharePrefs,child){
        return MaterialApp(
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
                  widget = NoteDetails.view(note.copy());
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
              case AccountPage.nameRoute:
                widget = AccountPage();
                break;
              default:
              // The assertion here will help remind
              // us of that higher up in the call stack, since
              // this assertion would otherwise fire somewhere
              // in the framework.
                assert(false, 'Need to implement ${settings.name}');
            }

            // MaterialPageRoute route = MaterialPageRoute(
            //   settings: settings,
            //   builder: (_)=> widget,
            // );
            // return route;

            return RouteAnimation.buildDefaultRouteTransition(widget, settings);
          },
          localizationsDelegates: [
            // AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('vi', ''), Locale('en', '')],
          localeListResolutionCallback: (locales, supportedLocales) {
            print('device locales=$locales supported locales=$supportedLocales');
            for (Locale locale in locales!) {
              // if device language is supported by the app,
              // just return it to set it as current app language
              if (supportedLocales.contains(locale)) {
                return locale;
              }
            }

            // if device language is not supported by the app,
            // the app will set it to english but return this to set to Bahasa instead
            return Locale('vi', '');
          },
          locale: Locale('vi', ''),
          theme: lightTheme(context,sharePrefs.materialColor),
          darkTheme: lightTheme(context,sharePrefs.materialColor),
        );
      },
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

      ChangeNotifierProxyProvider<Auth, NotesPublisher>(
        create: (_) => NotesPublisher(
            auth: FirebaseAuth.instance, fireStore: FirebaseFirestore.instance),
        lazy: true,
        update: (_, auth, preNotesProvider) {
          //TODO logic thay doi du lieu moi khi thay doi tai khoan nguoi dung
          print("updating notes Data ${auth.firebaseAuth.currentUser?.uid}");
          if (auth.firebaseAuth.currentUser == null)
            preNotesProvider?.clear();
          else {
            preNotesProvider?.config();
            preNotesProvider?.loadMoreNotes();
          }

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

      ChangeNotifierProxyProvider<Auth, QuotesProvider>(
        create: (_) => QuotesProvider(fireStore: FirebaseFirestore.instance),
        lazy: true,
        update: (_, userProvider, preTaskProvider) {
          // print("updating notes task provider");
          return preTaskProvider!;
        },
      ),

    ChangeNotifierProvider<SharePref>(
    create: (BuildContext context) => this.sharePref!)

    ], child: app);

    return multiProvider;
  }
}
