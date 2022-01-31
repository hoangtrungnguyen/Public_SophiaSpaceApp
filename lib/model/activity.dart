import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

List<Activity> activities = [
  Activity(id: "1", name: "Công việc", icon: Icons.work_outline),
  Activity(id: "2", name: "Bạn bè", icon: Icons.people_outline),
  Activity(id: "3", name: "Gia đình", icon: Icons.home_outlined),
  Activity(id: "4", name: "Giấc ngủ", icon: Icons.bed),
  Activity(id: "5", name: "Mối quan hệ", icon: Icons.supervisor_account),
  Activity(id: "6", name: "Trường học", icon: Icons.school),
  Activity(id: "7", name: "Đồ ăn", icon: Icons.emoji_food_beverage),
  Activity(id: "8", name: "Sức khỏe", icon: Icons.volunteer_activism),
  Activity(id: "9", name: "Sở thích", icon: Icons.piano),
  Activity(id: "10", name: "Thời tiết", icon: Icons.wb_sunny),
];


@JsonSerializable()
class Activity{
  String id;
  String? name;
  @JsonKey(ignore: true)
  IconData? icon;

  Activity({
    required this.id,
    this.icon,
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
