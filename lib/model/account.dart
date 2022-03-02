import 'package:sophia_hub/model/activity.dart';

class Account {
  String? loginEmail;
  String? loginPwd;
  String? registerName;

  List<Activity> _activities = defaultActivities;
  List<Activity> get activities => _activities;


  Account();

  setUserActivities({List<Activity> activities = const []}){
    _activities.addAll(activities);
  }
}
