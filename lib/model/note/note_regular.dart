import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_type.dart';

part 'note_regular.g.dart';

@JsonSerializable(explicitToJson: true)
class Note extends GenericNote implements Comparable<Note> {

  int? emotionPoint;

  List<Activity> activities = [];
  String? description;

  Note({
    String? title,
    String? description,
    List<Activity>? activities,
    int? emotionPoint,
  }) : super(NoteType.regular) {
    this.title = title;
    this.description = description;
    this.emotionPoint = emotionPoint;
    this.activities = activities ?? [];
    this.timeCreated = DateTime.now();
  }

  void addActivity(Activity activity) {
    if (activities.contains(activity)) return;
    this.activities.add(activity);
  }

  void removeActivity(Activity activity) {
    this.activities.remove(activity);
  }

  bool isValid() {
    if(emotionPoint == null){
      return false;
    }
    return  activities.length > 0 && emotionPoint! <= 10 && emotionPoint! >= 0;
  }

  Note copyContent() {
    return Note(
      emotionPoint: this.emotionPoint,
      description: this.description,
      title: this.title,
      activities: List.of(this.activities),
    )..id = this.id
    ..timeCreated = this.timeCreated;
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  /// Connect the generated [_$NoteToJson] function to the `toJson` method.

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  int compareTo(Note other) {
    //so that `a < b` iff `a.compareTo(b) < 0`.
    if (this.timeCreated.isAfter(other.timeCreated)) {
      return -1;
    } else if (this.timeCreated.isBefore(other.timeCreated)) {
      return 1;
    } else {
      return 0;
    }
  }

  //Method này sẽ tác động đến method List.contains(element). Hàm contains được sử dụng trong class NotesProviders
  @override
  bool operator ==(Object _other) {
    if (_other.runtimeType == Note) {
      Note other = _other as Note;
      return this.timeCreated.isAtSameMomentAs((other as Note).timeCreated) &&
          this.id == other.id &&
              this.description == other.description &&
              this.title == other.title &&
              this.activities == other.activities &&
              this.emotionPoint == other.emotionPoint;
    } else
      return false;
  }

  @override
  String toString() {
    return """{
      "emotionPoint": $emotionPoint,
      "title": $title,
      "description": $description,
      "timeCreated": $timeCreated,
      "activities": $activities,
      "type": $type,
    }""";
  }

}

// class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
//   const TimestampConverter();
//
//   @override
//   DateTime fromJson(Timestamp timestamp) {
//     return timestamp.toDate();
//   }
//
//   @override
//   Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
// }
