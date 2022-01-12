import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/configure/firebase_options.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/firebase_options.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/data_provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/auth_page.dart';
import 'package:sophia_hub/view/page/note/create_diary_note_page.dart';
import 'package:sophia_hub/view/page/task/create_task_page.dart';
import 'package:sophia_hub/view/page/task/list_task_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    MaterialApp app = MaterialApp(
      title: 'Small Habits',

      onGenerateRoute: (settings){
        //Read more in the link below
        // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
        WidgetBuilder builder;
        switch (settings.name) {
          case AuthPage.nameRoute:
            builder = (_) => AuthPage();
                break;
          case BaseContainer.nameRoute:
            builder = (_) => BaseContainer();
            break;
          case CreateDiaryNotePage.nameRoute:
            // Cast the arguments to the correct
            // type: Note.
            final note = settings.arguments as Note;
            builder = (_) => ChangeNotifierProvider.value(
                value: note, child: CreateDiaryNotePage());
            break;
          case CreateTaskPage.nameRoute:
            builder = (_) => CreateTaskPage();
            break;
          case ListTaskPage.nameRoute:
            builder = (_) => ListTaskPage();
            break;
          default:
            // The assertion here will help remind
            // us of that higher up in the call stack, since
            // this assertion would otherwise fire somewhere
            // in the framework.
            assert(false, 'Need to implement ${settings.name}');
        }

        MaterialPageRoute route = MaterialPageRoute(
          builder: builder,
        );
        return route;
      },
      theme: lightTheme(context),
      initialRoute: BaseContainer.nameRoute,

    );

    MultiProvider multiProvider = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppData()),
      ],
      child: app,
    );

    return multiProvider;
  }
}
