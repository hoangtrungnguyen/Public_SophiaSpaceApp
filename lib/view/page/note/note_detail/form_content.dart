import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/note_single_view_model.dart';

class NoteFormContent extends StatelessWidget {
  const NoteFormContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingleNoteViewModel viewModel = Provider.of<SingleNoteViewModel>(context);
    Note note = viewModel.note as Note;

    return Column(
      children: [
        Hero(
          tag: "title",
          child: Material(
            child: TextFormField(
              initialValue: note.title,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: "Tiêu đề",
              ),
              onChanged: (input) {
                note.title = input;
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
              initialValue: note.description,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                  // label: Text("Nội dung",style: TextStyle(color: textColor),),
                  hintText: "Suy nghĩ của bạn..."),
              maxLines: 10,
              minLines: 3,
              onChanged: (input) {
                note.description = input;
              },
            ),
          ),
        ),
      ],
    );
  }
}
