// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['category'],
  );
  return Quote(
    $enumDecode(_$QuoteCategoryEnumMap, json['category']),
    content: json['content'] as String?,
    imageUrl: json['imageUrl'] as String?,
    author: json['author'] == null
        ? null
        : Author.fromJson(json['author'] as Map<String, dynamic>),
  )..src = json['src'] as String?;
}

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'content': instance.content,
      'author': instance.author?.toJson(),
      'src': instance.src,
      'imageUrl': instance.imageUrl,
      'category': _$QuoteCategoryEnumMap[instance.category],
    };

const _$QuoteCategoryEnumMap = {
  QuoteCategory.general: 'general',
};
