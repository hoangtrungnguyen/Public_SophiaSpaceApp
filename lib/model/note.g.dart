// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      title: json['title'] as String?,
      description: json['description'] as String?,
      emotionPoint: json['emotionPoint'] as int? ?? 0,
    )..timeCreated = Note.timeCreatedFromJson(json['timeCreated'] as Timestamp);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'emotionPoint': instance.emotionPoint,
      'description': instance.description,
      'timeCreated': Note.timeCreatedToJson(instance.timeCreated),
    };
