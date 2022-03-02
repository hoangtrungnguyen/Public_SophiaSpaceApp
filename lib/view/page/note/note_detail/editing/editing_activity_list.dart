import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view/page/note/note_detail/editing/note_detail_is_editing.dart';

import 'editing_activity_grid.dart';

class EditingActivityList extends StatefulWidget {
  const EditingActivityList({Key? key}) : super(key: key);

  @override
  _ListActivitiesState createState() => _ListActivitiesState();
}

class _ListActivitiesState extends State<EditingActivityList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditingSingleNoteViewModel viewModel =
        Provider.of<EditingSingleNoteViewModel>(context);

    Color primary = Theme.of(context).colorScheme.primary;
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
                color: Theme.of(context).colorScheme.primary),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                List<Activity>? activities = await showDialog<List<Activity>?>(
                    context: context,
                    builder: (ctx) => _buildActivitiesDialog(ctx, viewModel));
                // print("updated activity:\n${activities}");
                if (activities != null) {
                  (viewModel.note as Note).activities = activities;
                  setState(() {});
                }
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
          ...(viewModel.note as Note).activities.map((e) {
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
                        if ((viewModel.note as Note).activities.length == 1)
                          return;
                        viewModel.removeActivity(e);
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

  Widget _buildActivitiesDialog(
      BuildContext context, EditingSingleNoteViewModel manager) {
    // print("build dialog ${List.of(note.activities)}");
    return Provider<List<Activity>>(
      create: (context) => List.of((manager.note as Note).activities),
      builder: (context, child) => SimpleDialog(
        title: Text(
          "Chọn hoạt động",
          textAlign: TextAlign.center,
        ),
        children: [
          Container(height: 300, width: 200, child: ActivityGrid()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  child: Icon(Icons.done_outline),
                  onPressed: () => Navigator.of(context)
                      .pop(context.read<List<Activity>>())),
              TextButton(
                child: Icon(Icons.cancel),
                onPressed: () async {
                  Navigator.of(context).pop(null);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
