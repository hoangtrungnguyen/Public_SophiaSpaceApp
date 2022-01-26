// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
    )
      ..authorId = json['author_id'] as String?
      ..authorName = json['author_name'] as String?
      ..src = json['src'] as String?;

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'content': instance.content,
      'src': instance.src,
      'image_url': instance.imageUrl,
    };
