import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/firebase_options.dart';
import 'package:sophia_hub/helper/route_observer.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/account/account_page.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';
import 'package:sophia_hub/view/page/note/create_note_page.dart';
import 'package:sophia_hub/view/page/task/create_task_page.dart';
import 'package:sophia_hub/view/page/task/list_task_page.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';
import 'package:sophia_hub/view_model/share_pref.dart';
import 'package:sophia_hub/view_model/ui_logic.dart';

import 'configure/app_config.dart';
import 'view/page/lock/lock_page.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((value) {
    });

    // await AppConfig.forEnvironment();

    SharedPref sharePref = SharedPref();
    await sharePref.init();

    runApp(SophiaHubApp(sharedPref: sharePref));
  }, (Object error, StackTrace stack) {
    // myBackend.sendError(error, stack);
    print("Send error's info to server: ${error} with stack $stack");
  });
}

class SophiaHubApp extends StatelessWidget {
  final SharedPref? sharedPref;

  SophiaHubApp({required this.sharedPref}) {}

  @override
  Widget build(BuildContext context) {
    //Configure App Small Habits
    Widget app = Consumer2<SharedPref, AccountViewModel>(
      builder: (context, sharePrefs, auth, child) {
        return MaterialApp(
          title: 'Sophia Space',
          navigatorObservers: [AppMiddleware()],
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? AuthPage.nameRoute
              : BaseContainer.nameRoute,
          onUnknownRoute: (setting) => MaterialPageRoute(
              builder: (_) =>
                  Center(child: Text("Không thể tìm thấy trang này"))),
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
              // case NoteDetails.nameRoute:
              //   // Cast the arguments to the correct
              //   // type: Note.
              //   try {
              //     Note note = settings.arguments as Note;
              //     widget = NoteDetails.view(note.copy());
              //   } catch (e) {
              //     print("Phải có object Note");
              //   }
              //   break;
              case CreateTaskPage.nameRoute:
                widget = CreateTaskPage();
                break;
              case ListTaskPage.nameRoute:
                widget = ListTaskPage();
                break;
              case AccountPage.nameRoute:
                widget = AccountPage();
                break;
              case LockPage.nameRoute:
                widget = LockPage();
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
          theme: lightTheme(context, sharePrefs.materialColor),
          darkTheme: lightTheme(context, sharePrefs.materialColor),
        );
      },
    );

    // Providers cần thiết.
    MultiProvider multiProvider = MultiProvider(providers: [


      ChangeNotifierProvider<SharedPref>(
          create: (BuildContext context) => this.sharedPref!),


      StreamProvider<firebase_auth.User?>(
        create: (_) => FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        updateShouldNotify: (pre, cur) => true,
      ),

      //UserProvider quan hệ phụ thuộc với firebase_auth.User
      // ProxyPrivider sẽ được thay đổi lại mỗi khi firbase_auth.User thay đổi.
      ChangeNotifierProxyProvider<firebase_auth.User?, AccountViewModel>(
        create: (_) => AccountViewModel(),
        update: (BuildContext context, firebaseUser,
            AccountViewModel? previous) {
          previous?.refresh();
          // return previous!;
          return previous!;
        },
      ),

      ChangeNotifierProxyProvider<AccountViewModel, QuoteViewModel>(
        create: (_) => QuoteViewModel(),
        lazy: true,
        update: (_, auth, preQuoteViewModel) {
          return preQuoteViewModel!;
        },
      ),


      ChangeNotifierProvider<UILogic>(
          create: (BuildContext context) => UILogic())
    ], child: app);

    return multiProvider;
  }
}

// class SophiaSpaceApp ex

