import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_regular.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';

class SingleNoteViewModel extends BaseViewModel<GenericNote> {
  late GenericNote _note;

  GenericNote get note => _note;

  set note(GenericNote note) {
    this._note = note;
    notifyListeners();
  }

  SingleNoteViewModel(GenericNote note) {
    this._note = note;
  }

  void refresh({required Note note}) {
    if(this._note is Note) {
      (this._note as Note).emotionPoint = note.emotionPoint;
      (this._note as Note).title = note.title;
      (this._note as Note).description = note.description;
      (this._note as Note).timeCreated = note.timeCreated;
      (this._note as Note).activities = note.activities;
      notifyListeners();
    } else {
      return;
    }
  }

  removeActivity(Activity activity) {
    if (note is Note) {
      (note as Note).removeActivity(activity);
      notifyListeners();
    }
  }

  addActivity(Activity activity) {
    if (note is Note) {
      (note as Note).addActivity(activity);
      notifyListeners();
    }
  }

  setEmotionPoint(int point) {
    if (note is Note) {
      (note as Note).emotionPoint = point;
      notifyListeners();
    }
  }

  @override
  String toString() {
    return "$note";
  }
}
