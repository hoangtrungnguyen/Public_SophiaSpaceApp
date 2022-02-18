import 'package:json_annotation/json_annotation.dart';

enum NoteType {
  @JsonValue("regular")
  REGULAR,
  @JsonValue("image")
  IMAGE,
  @JsonValue("sound")
  SOUND,
  @JsonValue("draw")
  DRAW
}
