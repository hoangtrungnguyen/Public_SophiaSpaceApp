import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class Author{
  String name;
  String? imageUrl;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  /// Connect the generated [_$AuthorToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  Author(this.name);


  @override
  String toString() {
    return """Author = {
    name: $name,
    imageUrl: $imageUrl
    }""";
  }
}