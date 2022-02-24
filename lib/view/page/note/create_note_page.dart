import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/page/note/create_note_step_1.dart';
import 'package:sophia_hub/view/page/note/create_note_step_2.dart';
import 'package:sophia_hub/view/page/note/create_note_step_3.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

class CreateNotePage extends StatefulWidget {
  static const String nameRoute = "/CreateNotePage";

  static Route<dynamic> route(NotesViewModel notesViewModel) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
          value: notesViewModel, child: CreateNotePage());
    });
  }

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SingleNoteViewModel>(
          create: (BuildContext context) => SingleNoteViewModel(Note(
            title: "",
            description: "",
          )),
        ),
        //This provider is to check if this screen is first screen
        Provider<bool>(
          create: (BuildContext context) => true,
        ),
        ListenableProvider<TabController>(
          create: (_) => tabController,
        )
      ],
      builder: (context, child) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(
                onPressed: () async {
                  if (tabController.index == 0) {
                    Navigator.of(context).pop(false);
                  } else {
                    int curIndex = tabController.index;
                    tabController.animateTo(curIndex - 1,
                        duration: Duration(milliseconds: 1000));
                  }
                },
              ),
              actions: [
                TextButton.icon(
                    onPressed: () async {
                      if (tabController.index == 0)
                        Navigator.of(context).pop(false);
                      else {
                        bool ok = await showDialog(
                            context: context, builder: _buildCancelDialog);
                        await Future.delayed(Duration(milliseconds: 500));
                        if (ok) Navigator.of(context).pop(false);
                      }
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    label: Container())
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.1,
                  1.0,
                ],
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
              )),
              child: Theme(
                data: Theme.of(context).copyWith(
                    scaffoldBackgroundColor: Colors.transparent,
                    textTheme: Theme.of(context).textTheme.apply(
                          bodyColor: Colors.white,
                          displayColor: Colors.white,
                        )),
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Builder(
                    builder: (BuildContext context) => TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        EmotionPointView(),
                        EmotionObjectsView(),
                        NoteDetailsView()
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
      // child:,
    );
  }

  Widget _buildCancelDialog(BuildContext context) {
    return AlertDialog(
      title:
          Text("Bạn có chắc chắc không?", style: TextStyle(color: Colors.red)),
      content: Text("Các thay đổi của bạn sẽ không được lưu"),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
            child: Icon(Icons.cancel_rounded),
            onPressed: () => Navigator.of(context).pop(false)),
        TextButton(
          child: Icon(Icons.done, color: Colors.red),
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
//Theme(
//                   data: Theme.of(context),
//                   child: Navigator(
//                     key: _keyNoteNavigator,
//                     onPopPage: (route, result) {
//                       print(route.settings.name);
//                       return true;
//                     },
//                     initialRoute: EmotionPointView.nameRoute,
//                     onGenerateRoute: (settings) {
//                       Widget? content;
//                       switch (settings.name) {
//                         case EmotionPointView.nameRoute:
//                           content = EmotionPointView();
//                           break;
//                         case EmotionObjectsView.nameRoute:
//                           content = EmotionObjectsView();
//                           break;
//                         case NoteDetailsView.nameRoute:
//                           content = NoteDetailsView();
//                           break;
//                         default:
//                           assert(false, "No matching name route");
//                       }
//
//                       Widget page = content!;
//                       return RouteAnimation.getCreateNoteRouteTransition(
//                           page, settings);
//                     },
//                   ),
