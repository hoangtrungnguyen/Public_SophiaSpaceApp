import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/helper.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/provider/app_data.dart';

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
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Note(
        title: "",
        description: "",
        day: Helper.generateTodayDailyDataId(),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Một ngày của bạn")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            EmotionPointRange(
              nextStep: nextStep,
            ),
            Detail()
          ],
        ),
      ),
    );
  }

  void nextStep() {
    _tabController.animateTo(1);
  }
}

class EmotionPointRange extends StatelessWidget {
  final Function nextStep;

  const EmotionPointRange({Key key, this.nextStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Spacer(),
        ElevatedButton(onPressed: nextStep, child: Text("Tiếp tục"))
      ]),
    );
  }
}

class Detail extends StatelessWidget {
  const Detail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text("Tiêu đề")),
              style: TextStyle(),
              onChanged: (input) {
                note.title = input;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text("Nội dung")),
              maxLines: 10,
              minLines: 3,
              style: TextStyle(),
              onChanged: (input) {
                note.description = input;
              },
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Provider.of<AppData>(context, listen: false)
                      .addNote(todayId: generateTodayDailyDataId(), note: note);
                  Navigator.maybePop(context);
                },
                child: Text("Thêm note"))
          ],
        ),
      ),
    );
  }
}
