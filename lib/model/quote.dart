import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/quote/quote_category.dart';

import 'author.dart';

part 'quote.g.dart';

@JsonSerializable(explicitToJson: true)
class Quote {
  @JsonKey(ignore: true)
  late String id;

  String? content;

  Author? author;

  String? src;

  String? imageUrl;

  @JsonKey(required: true)
  late QuoteCategory category;

  Quote(this.category,{
    this.content,
    this.imageUrl,
    this.author,
  });


  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Connect the generated [_$QuoteToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteToJson(this);


  @override
  String toString() {
    return """{
      content: $content,
      author: $author,
      imageUrl: $imageUrl
    }""";
  }

}