import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/note/note_type.dart';

abstract class GenericNote {
  String? _id;

  String? title;

  @JsonKey(required: true,)
  late NoteType type;


  @JsonKey(
    fromJson: timeCreatedFromJson,
    toJson: timeCreatedToJson,
  )
  late DateTime timeCreated;

  static DateTime timeCreatedFromJson(Timestamp timestamp) =>
      timestamp.toDate();

  static Timestamp timeCreatedToJson(DateTime date) => Timestamp.fromDate(date);

  GenericNote(this.type,{
    this.title,
  }){
    timeCreated = DateTime.now();
  }



  @JsonKey(ignore: true)
  String get id => _id ?? "NaN";

  //Chỉ cho phép đặt Id một lần
  set id(String id) {
    if (_id != null)
      assert(false, "Note đã có id nên không thể thay đổi");
    else
      _id = id;
  }

  bool isValid();

  GenericNote.empty();

}