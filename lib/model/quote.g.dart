// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      authorName: json['authorName'] as String?,
    )
      ..authorId = json['authorId'] as String?
      ..src = json['src'] as String?;

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'content': instance.content,
      'src': instance.src,
      'imageUrl': instance.imageUrl,
    };
