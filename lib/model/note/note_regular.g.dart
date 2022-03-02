// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_regular.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type'],
  );
  return Note(
    title: json['title'] as String?,
    description: json['description'] as String?,
    activities: (json['activities'] as List<dynamic>?)
        ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList(),
    emotionPoint: json['emotionPoint'] as int?,
  )
    ..type = $enumDecode(_$NoteTypeEnumMap, json['type'])
    ..timeCreated =
        GenericNote.timeCreatedFromJson(json['timeCreated'] as Timestamp);
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'type': _$NoteTypeEnumMap[instance.type],
      'timeCreated': GenericNote.timeCreatedToJson(instance.timeCreated),
      'emotionPoint': instance.emotionPoint,
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'description': instance.description,
    };

const _$NoteTypeEnumMap = {
  NoteType.regular: 'regular',
  NoteType.image: 'image',
  NoteType.SOUND: 'sound',
  NoteType.DRAW: 'draw',
};
