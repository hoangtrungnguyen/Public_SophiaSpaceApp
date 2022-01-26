import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote with ChangeNotifier {
  @JsonKey(ignore: true)
  late String id;
  @JsonKey(name: "author_id")
  String? authorId;

  @JsonKey(name: "author_name")
  String? authorName;

  String? content;

  String? src;

  @JsonKey(name: "image_url")
  String? imageUrl;

  Quote({
    this.content,
    this.imageUrl,
  });


  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// Connect the generated [_$QuoteToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuoteToJson(this);


}