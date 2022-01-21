// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      title: json['title'] as String?,
      description: json['description'] as String?,
      emotionPoint: json['emotion_point'] as int,
    )..timeCreated =
        Note.timeCreatedFromJson(json['time_created'] as Timestamp);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'emotion_point': instance.emotionPoint,
      'title': instance.title,
      'description': instance.description,
      'time_created': Note.timeCreatedToJson(instance.timeCreated),
    };
