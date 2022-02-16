import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote with ChangeNotifier {
  @JsonKey(ignore: true)
  late String id;

  String? authorId;

  String? authorName;

  String? content;

  String? src;

  String? imageUrl;

  Quote({
    this.content,
    this.imageUrl,
    this.authorName,
  });


  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Connect the generated [_$QuoteToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteToJson(this);


  @override
  String toString() {
    return """{
      content: $content,
      authorName: $authorName,
      imageUrl: $imageUrl
    }""";
  }

}