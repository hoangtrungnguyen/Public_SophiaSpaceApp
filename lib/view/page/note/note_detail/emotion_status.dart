import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/helper/note_helper_func.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

class EmotionStatus extends StatelessWidget {
  const EmotionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingleNoteViewModel viewModel = Provider.of<SingleNoteViewModel>(context);
    Note note = viewModel.note as Note;
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      height: 120,
      child: Stack(
        children: [
          Align(
            child: Hero(
              tag: "mood icon",
              child: Icon(
                generateMoodIcon(note.emotionPoint!),
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
                    note.emotionPoint!.toInt())}",
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
    );
  }
}
