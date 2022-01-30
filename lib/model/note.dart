import 'dart:collection';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/activity.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note with ChangeNotifier implements Comparable<Note> {
  @JsonKey(ignore: true)
  String? _id;
  @JsonKey(name: 'emotion_point')
  int emotionPoint = 0;
  @JsonKey(ignore: true)
  late LinkedHashSet<Activity> activities;
  String? title;
  String? description;
  @JsonKey(
    name: 'time_created',
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
    notifyListeners();
  }

  Note({
    this.title,
    this.description,
    LinkedHashSet<Activity>? activities,
    required this.emotionPoint,
  }) {
    this.activities = activities ?? LinkedHashSet.from([]);
    this.timeCreated = DateTime.now();
  }

  addActivity(Activity emotion) {
    this.activities.add(emotion);
    notifyListeners();
  }

  void removeActivity(Activity emotion) {
    this.activities.remove(emotion);
    notifyListeners();
  }

  bool isValid() =>
      activities.length > 0 && emotionPoint <= 10 && emotionPoint >= 0;

  Note copy() {
    return Note(
      emotionPoint: this.emotionPoint,
      description: this.description,
      title: this.title,
      activities: this.activities,
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
      "time_created": ${timeCreated},
      "activities": $activities,
    }""";
  }

  refresh({Note? note}) {
    if(note != null) {
    this.emotionPoint = note.emotionPoint;
    this.title = note.title;
    this.description = note.description;
    this.timeCreated = note.timeCreated;
    this.activities = note.activities;
    }
    notifyListeners();
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
