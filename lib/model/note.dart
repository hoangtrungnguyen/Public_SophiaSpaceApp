import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/activity.dart';
import 'package:sophia_hub/model/note/note.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note extends GenericNote implements Comparable<Note> {
  @JsonKey(ignore: true)
  String? _id;
  int emotionPoint = 0;
  @JsonKey(ignore: true)
  late List<Activity> activities;

  String? description;
  @JsonKey(
    fromJson: timeCreatedFromJson,
    toJson: timeCreatedToJson,
  )
  late DateTime timeCreated;

  static DateTime timeCreatedFromJson(Timestamp timestamp) =>
      timestamp.toDate();

  static Timestamp timeCreatedToJson(DateTime date) => Timestamp.fromDate(date);

  @JsonKey(ignore: true)
  String get id => _id ?? "NaN";

  //Chỉ cho phép đặt Id một lần
  set id(String id) {
    if (_id != null)
      assert(false, "Note đã có id nên không thể thay đổi");
    else
      _id = id;
  }

  set point(int point) {
    this.emotionPoint = point;
  }

  Note({
    String? title,
    String? description,
    List<Activity>? activities,
    int emotionPoint = 0, String id = "NaN",
  }) {
    this.title = title;
    this.description = description;
    this.emotionPoint = 0;
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

  bool isValid() =>
      activities.length > 0 && emotionPoint <= 10 && emotionPoint >= 0;

  Note copy() {
    return Note(
      emotionPoint: this.emotionPoint,
      description: this.description,
      title: this.title,
      activities: List.of(this.activities),
    )
      ..timeCreated = this.timeCreated
      ..id = _id ?? 'NaN';
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
      return /*this.timeCreated.isAtSameMomentAs((other as Note).timeCreated) &&*/
          this.id == other.id &&
              this.description == other.description &&
              this.title == other.title &&
              // this.activities == other.activities &&
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
      "timeCreated": ${timeCreated},
      "activities": $activities,
    }""";
  }

   Note.empty() {}
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
