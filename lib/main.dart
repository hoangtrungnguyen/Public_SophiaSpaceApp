import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/provider/data_provider.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/diary/create_diary_note_page.dart';
import 'package:sophia_hub/view/page/task/create_task_page.dart';
import 'package:sophia_hub/view/page/task/list_task_page.dart';

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
      title: 'Small Habits',
      routes: {
        BaseContainer.nameRoute: (_) => BaseContainer(),
        CreateDiaryNotePage.nameRoute: (_) => CreateDiaryNotePage(),
        CreateTaskPage.nameRoute: (_) => CreateTaskPage(),
        ListTaskPage.nameRoute: (_) => ListTaskPage(),
      },
      theme: lightTheme(context),
      home: BaseContainer(),
    );

    MultiProvider multiProvider = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Data()
        ),
      ],
      child: app,
    );

    return multiProvider;
  }
}
