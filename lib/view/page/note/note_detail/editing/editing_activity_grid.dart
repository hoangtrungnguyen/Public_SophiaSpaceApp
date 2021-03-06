import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/view_model/account_view_model.dart';

class ActivityGrid extends StatefulWidget {
  const ActivityGrid({Key? key}) : super(key: key);

  @override
  _ActivityGridState createState() => _ActivityGridState();
}

class _ActivityGridState extends State<ActivityGrid> {
  late List<Activity> _activities;

  @override
  void initState() {
    _activities = Provider.of<AccountViewModel>(context,listen: false).account.activities;
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
          bool isChosen = Provider.of<List<Activity>>(context, listen: false).contains(activity);
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(activity.icon),
                    Text(
                      '${activity.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    )
                  ]),
            ),
          );
        });
  }
}
