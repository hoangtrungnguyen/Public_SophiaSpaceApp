import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

class EmotionObjectsView extends StatefulWidget {
  static const String nameRoute = "/EmotionObjectsView";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return EmotionObjectsView();
    });
  }

  @override
  _EmotionObjectsViewState createState() => _EmotionObjectsViewState();
}

class _EmotionObjectsViewState extends State<EmotionObjectsView> {

  @override
  void initState() {
    super.initState();
    (Provider.of<SingleNoteViewModel>(context,listen: false).note as Note).activities = [];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<SingleNoteViewModel>(
        builder: (BuildContext context, manager, Widget? child) {
          Note value = manager.note as Note;
          Widget button;
          button = FloatingActionButton.extended(
             elevation: value.activities.isEmpty ? 0 : 6,
              backgroundColor: value.activities.isEmpty
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.white,
              onPressed: value.activities.isEmpty
                  ? null
                  : () {
                    Provider.of<TabController>(context,listen: false).animateTo(2,
                    duration: Duration(milliseconds: 1000));
                  },
              label:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Tiếp tục",
                  style: Theme.of(context).textTheme.headline6?.apply(
                    color: value.activities == null
                        ? Colors.grey.withOpacity(0.5)
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),);
          return button;
        },
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
            "Điều gì khiến bạn cảm thấy như vậy?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          Spacer(
            flex: 4,
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: EmotionGrid(),
          ),
          Spacer(
            flex: 5,
          )
        ],
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
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
  Widget build(BuildContext context) {
    SingleNoteViewModel viewModel = Provider.of<SingleNoteViewModel>(context);
    return GridView.builder(
      shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _activities.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          Activity emotion = _activities[index];
          bool isChosen = (viewModel.note as Note).activities.contains(emotion);
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor:
                MaterialStateProperty.all<Color?>(isChosen ? Theme.of(context).colorScheme.primary : Colors.grey)
              ),
              onPressed: () {
                if (isChosen) {
                  viewModel.removeActivity(emotion);
                } else {
                  viewModel.addActivity(emotion);
                }
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(emotion.icon),
                    Text(
                      '${emotion.name}',
                      textAlign: TextAlign.center,
                    )
                  ]),
            ),
          );
        });
  }
}
