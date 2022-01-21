import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Quote with ChangeNotifier {
  String? author;
  String? content;
  String? imageUrl;

  Quote({
    this.author,
    this.content,
    this.imageUrl,
  });
}