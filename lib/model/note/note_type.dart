import 'package:json_annotation/json_annotation.dart';

enum NoteType {
  @JsonValue("regular")
  regular,
  @JsonValue("image")
  image,
  @JsonValue("sound")
  SOUND,
  @JsonValue("draw")
  DRAW
}
