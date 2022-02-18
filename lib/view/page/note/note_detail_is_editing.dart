import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/single_note_view_model.dart';


class EditingNoteDetails extends StatefulWidget {
  static const String nameRoute = "/NoteDetails";

  static Route<Note> route(Note note) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return EditingNoteDetails.view(note);
    });
  }

  static Widget view(Note note) {
    return ChangeNotifierProvider<SingleNoteViewModel>(
      // value: note,
      create: (_) =>SingleNoteViewModel(note),
      // child: EditingNoteDetails(),
      builder: (context, child) {
        return EditingNoteDetails();
      },
    );
  }

  @override
  _EditingNoteDetailsState createState() => _EditingNoteDetailsState();
}

class _EditingNoteDetailsState extends State<EditingNoteDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme
        .of(context)
        .colorScheme
        .primary;
    SingleNoteViewModel singleNoteManager = Provider.of<SingleNoteViewModel>(context);
    NotesViewModel viewModel = Provider.of<NotesViewModel>(context);
    return Scaffold(
        floatingActionButton: Selector<NotesViewModel ,ConnectionState>(
          selector: (_, viewModel) => viewModel.appConnectionState,
          builder: (context,data, child){
            bool isWaiting = data == ConnectionState.waiting;
            return FloatingActionButton(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: isWaiting ? AnimatedLoadingIcon(color: Colors.white,): Icon(Icons.done),
                  onPressed: isWaiting
                      ? null
                      : () async {
                    bool isOk = await viewModel.update(note:singleNoteManager.note);
                    if (isOk) {
                      Navigator.of(context).pop<Note?>(singleNoteManager.note);
                    } else {
                      showErrMessage(context, viewModel.error!);
                    }
                  },
                );

          },
        ),
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          leading: Container(),
          actions: [
            Hero(
              tag: "backButton",
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 26, right: 16, bottom: 26),
                  height: 50,
                  width: 50,
                  decoration: ShapeDecoration(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop<Note?>(context);
                    },
                    child: Icon(Icons.close_rounded),
                  )),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: Hero(
            tag: "appBarTitle",
            child: Text(
              "${DateFormat.yMd().add_jm().format(singleNoteManager.note.timeCreated)}",
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120,
                    child: Stack(
                      children: [
                        Align(
                          child: Hero(
                            tag: "mood icon",
                            child: Icon(
                              generateMoodIcon(singleNoteManager.note.emotionPoint),
                              color: primary.withOpacity(0.1),
                              size: 80,
                            ),
                          ),
                          alignment: Alignment(0, -0.2),
                        ),
                        Align(
                          child: Hero(
                            tag: "mood text",
                            child: Text(
                              "${generateMoodStatus(
                                  singleNoteManager.note.emotionPoint.toInt())}",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                  color: primary.withOpacity(0.8),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SliderEmotionPoint(),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ListActivities()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Hero(
                            tag: "title",
                            child: Material(
                              child: TextFormField(
                                initialValue: singleNoteManager.note.title,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                                  hintText: "Tiêu đề",
                                ),
                                onChanged: (input) {
                                  singleNoteManager.note.title = input;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Hero(
                            tag: "content",
                            child: Material(
                              child: TextFormField(
                                initialValue: singleNoteManager.note.description,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                                  // label: Text("Nội dung",style: TextStyle(color: textColor),),
                                    hintText: "Suy nghĩ của bạn..."),
                                maxLines: 10,
                                minLines: 3,
                                onChanged: (input) {
                                  singleNoteManager.note.description = input;
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              )),
        ));
  }
}

class SliderEmotionPoint extends StatefulWidget {
  const SliderEmotionPoint({Key? key}) : super(key: key);

  @override
  _SliderEmotionPointState createState() => _SliderEmotionPointState();
}

class _SliderEmotionPointState extends State<SliderEmotionPoint> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SingleNoteViewModel viewModel = Provider.of<SingleNoteViewModel>(context);
    return Slider(
      inactiveColor: Colors.grey.withOpacity(0.5),
      activeColor: Theme
          .of(context)
          .colorScheme
          .primary,
      value: viewModel.note.emotionPoint.toDouble(),
      min: 0,
      max: 10,
      divisions: 10,
      label: "${viewModel.note.emotionPoint}",
      onChanged: (double value) {
        viewModel.note.emotionPoint = value.toInt();
        setState(() {});
      },
    );
  }
}

class ListActivities extends StatefulWidget {
  const ListActivities({Key? key}) : super(key: key);

  @override
  _ListActivitiesState createState() => _ListActivitiesState();
}

class _ListActivitiesState extends State<ListActivities> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SingleNoteViewModel manager = Provider.of<SingleNoteViewModel>(context);

    Color primary = Theme
        .of(context)
        .colorScheme
        .primary;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 16,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: ShapeDecoration(
                shape: continuousRectangleBorder,
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                List<Activity>? activities = await showDialog<List<Activity>?>(
                    context: context,
                    builder: (ctx) => _buildActivitiesDialog(ctx, manager));
                // print("updated activity:\n${activities}");
                if (activities != null)
                  manager.note.activities = activities;
                setState(() {

                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          ...manager.note.activities.map((e) {
            return Hero(
                tag: "emotions ${e.id}",
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Material(
                    child: InputChip(
                      deleteIcon: Icon(
                        Icons.cancel_outlined,
                        color: primary.withOpacity(0.5),
                      ),
                      onDeleted: () {
                        print('deleted');
                        if(manager.note.activities.length == 1) return;
                        manager.removeActivity(e);
                      },
                      backgroundColor: Colors.white,
                      avatar: Icon(
                        e.icon,
                        color: primary,
                      ),
                      label: Text(
                        e.name ?? "NaN",
                      ),
                    ),
                  ),
                ));
          }).toList(),
          SizedBox(
            width: 16,
          ),
        ]),
      ),
    );
  }

  Widget _buildActivitiesDialog(BuildContext context, SingleNoteViewModel manager) {
    // print("build dialog ${List.of(note.activities)}");
    return Provider<List<Activity>>(
      create: (context) => List.of(manager.note.activities),
      builder: (context, child) =>
          SimpleDialog(
            title: Text(
              "Chọn hoạt động",
              textAlign: TextAlign.center,
            ),
            children: [
              Container(height: 300, width: 200, child: EmotionGrid()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      child: Icon(Icons.done_outline),
                      onPressed: () =>
                          Navigator.of(context)
                              .pop(context.read<List<Activity>>())),
                  TextButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              )
            ],
          ),
    );
  }
}

class NoteActivityIcon extends StatefulWidget {
  final Activity e;

  NoteActivityIcon(this.e, {Key? key}) : super(key: key);

  @override
  State<NoteActivityIcon> createState() => _NoteActivityIconState();
}

class _NoteActivityIconState extends State<NoteActivityIcon> {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme
        .of(context)
        .colorScheme
        .primary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        child: InputChip(
          deleteIcon: Icon(
            Icons.cancel_outlined,
            color: primary.withOpacity(0.5),
          ),
          onDeleted: () {
            print('deleted');
          },
          backgroundColor: Colors.white,
          avatar: Icon(
            widget.e.icon,
            color: primary,
          ),
          label: Text(
            widget.e.name ?? "NaN",
          ),
        ),
      ),
    );
  }
}

class EmotionGrid extends StatefulWidget {
  const EmotionGrid({Key? key}) : super(key: key);

  @override
  _EmotionGridState createState() => _EmotionGridState();
}

class _EmotionGridState extends State<EmotionGrid> {
  List<Activity> _activities = activities;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _activities.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          Activity activity = _activities[index];
          bool isChosen = Provider
              .of<List<Activity>>(context, listen: false).contains(activity);

          return Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: Theme
                  .of(context)
                  .elevatedButtonTheme
                  .style
                  ?.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color?>(isChosen
                      ? Theme
                      .of(context)
                      .colorScheme
                      .primary
                      : Colors.grey)),
              onPressed: () {
                setState(() {
                  // print("chosenActivities ${Provider
                  //     .of<List<Activity>>(context, listen: false)
                  //     .length}");
                  if (isChosen) {
                    if(Provider.of<List<Activity>>(context, listen: false).length == 1) return;
                    Provider.of<List<Activity>>(context, listen: false).remove(activity);
                  } else {
                    Provider
                        .of<List<Activity>>(context, listen: false).add(activity);
                  }
                });
              },
              child: Icon(activity.icon),
            ),
          );
        });
  }
}
