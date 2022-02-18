// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteImage _$NoteImageFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type'],
  );
  return NoteImage(
    imageUrls: (json['imageUrls'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
  )
    ..title = json['title'] as String?
    ..type = $enumDecode(_$NoteTypeEnumMap, json['type'])
    ..timeCreated =
        GenericNote.timeCreatedFromJson(json['timeCreated'] as Timestamp);
}

Map<String, dynamic> _$NoteImageToJson(NoteImage instance) => <String, dynamic>{
      'title': instance.title,
      'type': _$NoteTypeEnumMap[instance.type],
      'timeCreated': GenericNote.timeCreatedToJson(instance.timeCreated),
      'imageUrls': instance.imageUrls,
    };

const _$NoteTypeEnumMap = {
  NoteType.REGULAR: 'regular',
  NoteType.IMAGE: 'image',
  NoteType.SOUND: 'sound',
  NoteType.DRAW: 'draw',
};
