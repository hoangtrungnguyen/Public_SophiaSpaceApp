import 'package:flutter/cupertino.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note.dart';

class SingleNoteManager extends ChangeNotifier {
  Note note;

  SingleNoteManager(this.note);

  void refresh({Note? note}) {
    if (note != null) {
      this.note.emotionPoint = note.emotionPoint;
      this.note.title = note.title;
      this.note.description = note.description;
      this.note.timeCreated = note.timeCreated;
      this.note.activities = note.activities;
    }
  }

  removeActivity(Activity activity){
    note.removeActivity(activity);
    notifyListeners();
  }
  addActivity(Activity activity){
    note.addActivity(activity);
    notifyListeners();
  }
}
