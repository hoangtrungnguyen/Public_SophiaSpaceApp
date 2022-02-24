import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

class SliderEmotionPoint extends StatelessWidget {
  const SliderEmotionPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleNoteViewModel>(
        builder: (context, viewModel, child){
          Note note = viewModel.note as Note;
          return Slider(
            inactiveColor: Colors.grey.withOpacity(0.5),
            activeColor: Theme
                .of(context)
                .colorScheme
                .primary,
            value: note.emotionPoint!.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            label: "${note.emotionPoint}",
            onChanged: (double value) {
              viewModel.setEmotionPoint(value.toInt());
            },
          );
        },
    );
  }
}
