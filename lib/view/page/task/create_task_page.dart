import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/model/task.dart';
import 'package:sophia_hub/provider/app_data.dart';

class CreateTaskPage extends StatefulWidget{
    static const String nameRoute = "/CreateTaskPage";

    static Route<dynamic> route(){
        return MaterialPageRoute(
            builder: (BuildContext context){
                return CreateTaskPage();
            }
        );
    }
    @override
    _CreateTaskPageState createState() =>  _CreateTaskPageState();
}

class  _CreateTaskPageState extends State<CreateTaskPage>{
    Task task = Task();

    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
            title: Text("Thêm nhiệm vụ ngày")
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(onPressed: () async {
          //Chọn ngày hiện tại và thêm vào danh sách
          Navigator.pop(context,"ok");
        },
            label:  Text("Thêm")),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: Column(
            children: [
              TextFormField(
                decoration:InputDecoration(label: Text("Tên nhiệm vụ")),
                onChanged: (data){
                  this.task.title = data;
                },
                style: TextStyle(
                ),
              ),
              TextFormField(
                decoration:InputDecoration(label: Text("Mô tả")),
                maxLines: 20,
                minLines: 5,
                onChanged: (data){
                  this.task.description = data;
                },
                style: TextStyle(
                ),
              ),

            ],
          ),),
      );
    }
}