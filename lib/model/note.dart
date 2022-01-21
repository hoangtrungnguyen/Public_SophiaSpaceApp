import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/emotion.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note with ChangeNotifier {
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

  Note({
    this.title,
    this.description,
    LinkedHashSet<Emotion>? emotions,
    required this.emotionPoint,
  }) {
    this.timeCreated = DateTime.now();
    this.emotions = emotions ?? LinkedHashSet.from([]);
  }

  bool isValid() =>
      emotions.length > 0 && emotionPoint <= 10 && emotionPoint >= 0;

  static DateTime timeCreatedFromJson(Timestamp timestamp) =>
      timestamp.toDate();

  static Timestamp timeCreatedToJson(DateTime date) => Timestamp.fromDate(date);

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
