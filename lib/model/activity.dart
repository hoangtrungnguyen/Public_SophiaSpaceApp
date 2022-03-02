import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sophia_hub/model/icon_pool.dart';

part 'activity.g.dart';

List<Activity> defaultActivities = [
  Activity(id: "1", name: "Công việc", iconCode: "${Icons.work_outline.codePoint}"),
  Activity(id: "2", name: "Bạn bè", iconCode: "${Icons.people_outline.codePoint}"),
  Activity(id: "3", name: "Gia đình", iconCode: "${Icons.home_outlined.codePoint}"),
  Activity(id: "4", name: "Giấc ngủ", iconCode: "${Icons.bed.codePoint}"),
  Activity(id: "5", name: "Mối quan hệ", iconCode: "${Icons.supervisor_account.codePoint}"),
  Activity(id: "6", name: "Trường học", iconCode: "${Icons.school.codePoint}"),
  Activity(id: "7", name: "Đồ ăn", iconCode: "${Icons.emoji_food_beverage.codePoint}"),
  Activity(id: "8", name: "Sức khỏe", iconCode: "${Icons.volunteer_activism.codePoint}"),
  Activity(id: "9", name: "Sở thích", iconCode: "${Icons.piano.codePoint}"),
  Activity(id: "10", name: "Thời tiết", iconCode: "${Icons.wb_sunny.codePoint}"),
];


@JsonSerializable()
class Activity{
  String id;
  String? name;

  String? iconCode;

  @JsonKey(ignore: true)
  IconData? get icon {
    return iconPool[iconCode];
  }

  Activity({
    required this.id,
    this.iconCode,
    this.name,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  /// Connect the generated [_$ActivityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  String toString() {
    return """{
      "id": $id,
      "name": $name,
    }""";
  }

  @override
  bool operator ==(Object _other) {
    if (_other.runtimeType == Activity) {
      Activity other = _other as Activity;
      return this.id == other.id;
    } else
      return false;
  }
}
