import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/note/note.dart';
import 'package:sophia_hub/model/note/note_type.dart';

part 'note_image.g.dart';

@JsonSerializable(explicitToJson: true)
class NoteImage extends GenericNote {

  List<String> imageUrls = [];

  @JsonKey(ignore: true)
  List<String> imageUris = [];

  NoteImage({this.imageUrls = const []}) : super(NoteType.IMAGE);

  @override
  bool isValid() => imageUrls.length > 0;

}
