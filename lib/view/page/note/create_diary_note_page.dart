import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/view/page/note/set_emotion_objects_view.dart';
import 'package:sophia_hub/view/page/note/set_emotion_point_view.dart';
import 'package:sophia_hub/view/page/note/set_note_details_view.dart';

class CreateDiaryNotePage extends StatefulWidget {
  static const String nameRoute = "/CreateDiaryNotePage";

  static Route<dynamic> route(Note note) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
          value: note, child: CreateDiaryNotePage());
    });
  }

  @override
  _CreateDiaryNotePageState createState() => _CreateDiaryNotePageState();
}

class _CreateDiaryNotePageState extends State<CreateDiaryNotePage>
    with SingleTickerProviderStateMixin {
  LabeledGlobalKey _keyNoteNavigator =
      LabeledGlobalKey<NavigatorState>("note_navigator");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Note(
            title: "",
            description: "",
            emotionPoint: 0,
            emotions: LinkedHashSet(),
          ),
        ),
        //This provider is to check if this screen is first screen
        Provider<bool>(
          create: (BuildContext context) => true,
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () async {
                if (!await Navigator.of(_keyNoteNavigator.currentContext!)
                    .maybePop()) {
                  Navigator.of(context).pop(false);
                }
                ;
              },
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  label: Container())
            ],
          ),
          body: Navigator(
            key: _keyNoteNavigator,
            onPopPage: (route, result) {
              print(route.settings.name);
              return true;
            },
            initialRoute: EmotionPointView.nameRoute,
            onGenerateRoute: (settings) {
              WidgetBuilder? builder;

              Widget? content;
              switch (settings.name) {
                case EmotionPointView.nameRoute:
                  content = EmotionPointView();
                  break;
                case EmotionObjectsView.nameRoute:
                  content = EmotionObjectsView();
                  break;
                case NoteDetailsView.nameRoute:
                  content = NoteDetailsView();
                  break;
                default:
                  assert(false, "No matching name route");
              }

              Widget view = content!;

              builder = (_) => view;
              return MaterialPageRoute(
                settings: settings,
                builder: builder,
              );
            },
          )),
    );
  }
}
