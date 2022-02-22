import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/view/widget/animated_loading_icon.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';

class NoteViewHolder extends StatelessWidget {
  const NoteViewHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<NotesViewModel, ConnectionState>(
        selector: (_, viewModel) => viewModel.appConnectionState,
        builder: (ctx, data, child) {
          bool isLoading = data == ConnectionState.waiting;
          if (isLoading)
            return AnimatedLoadingIcon(size: 50,);
          return Container();
        });
  }
}
