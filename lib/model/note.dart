import 'dart:collection';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/emotion.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note with ChangeNotifier implements Comparable<Note> {
  @JsonKey(ignore: true)
  String? _id;
  @JsonKey(name: 'emotion_point')
  int emotionPoint = 0;
  @JsonKey(ignore: true)
  late LinkedHashSet<Emotion> emotions;
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

  String get id => _id ?? "NaN";

  //Chỉ cho phép đặt Id một lần
  set id(String id) {
    if (_id != null)
      assert(false, "Note đã có id nên không thể thay đổi");
    else
      _id = id;
  }

  set point(int point){
    this.emotionPoint = point;
    notifyListeners();
  }

  Note({
    this.title,
    this.description,
    LinkedHashSet<Emotion>? emotions,
    required this.emotionPoint,
  }) {
    this.emotions = emotions ?? LinkedHashSet.from([]);
    this.timeCreated = DateTime.now();
  }

  addEmotion(Emotion emotion) {
    this.emotions.add(emotion);
    notifyListeners();
  }

  void removeEmotion(Emotion emotion) {
    this.emotions.remove(emotion);
    notifyListeners();
  }

  bool isValid() =>
      emotions.length > 0 && emotionPoint <= 10 && emotionPoint >= 0;

  @override
  String toString() {
    return """{
      "emotionPoint": $emotionPoint,
      "title": $title,
      "description": $description,
      "time_created": ${timeCreated},
      "emotions": $emotions,
    }""";
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

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == Note)
      return /*this.timeCreated.isAtSameMomentAs((other as Note).timeCreated) &&*/
          this.id == (other as Note).id;
    else
      return false;
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
