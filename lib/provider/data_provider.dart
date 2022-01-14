import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:sophia_hub/model/daily_data.dart';
import 'package:sophia_hub/model/note.dart';
import 'package:sophia_hub/model/quote.dart';

class AppData extends ChangeNotifier {
  List<DailyData> listData = [];
  List<Quote> quotes = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AppData() {
    Future.microtask(() async{
          //Lấy dữ liều từ server và thêm vào danh sách
           await Future.delayed(Duration(seconds: 2),);
           listData.addAll([
             DailyData()..time = DateTime.now().subtract(Duration(days: 2)),
             DailyData()..time = DateTime.now().subtract(Duration(days: 3))
           ]);
          //Thêm phần từ dữ liệu ngày hôm nay nếu không có
          listData.add(
            DailyData()..time = DateTime.now()
          );
//          notifyListeners();
        });
  }

  addNote(DailyData data) async {
    //lấy ngày hiện tại và thêm note
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = FirebaseAuth.instance.currentUser.uid;
    String dailyDataId = data.id;

    CollectionReference dailyDataCollection = FirebaseFirestore.instance.collection('daily_data_collection');

    // Call the user's CollectionReference to add a new user
//    dailyDataCollection
//        .doc(uid).collection(dailyDataId).doc().collection()
//
//        .then((value) => print("User Added"))
//        .catchError((error) => print("Failed to add user: $error"));
  }




}
