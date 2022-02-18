import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';

class SingleNoteViewModel<GenericNote> extends BaseViewModel {
  GenericNote note;

  SingleNoteViewModel(this.note);

  void refresh({Note? note}) {
    if (note is Note) {
      (note).emotionPoint = note.emotionPoint;
      (note).title = note.title;
      (note).description = note.description;
      (note).timeCreated = note.timeCreated;
      (note).activities = note.activities;
    } else {
      return;
    }
  }

  removeActivity(Activity activity){
    if(note is Note) {
      (note as Note).removeActivity(activity);
      notifyListeners();
    }
  }
  addActivity(Activity activity){
    if(note is Note) {
      (note as Note).addActivity(activity);
      notifyListeners();
    }
  }
}
