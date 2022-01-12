import 'package:flutter/material.dart';

class ListTaskPage extends StatefulWidget{
    static const String nameRoute = "/ListTaskPage";

    static Route<dynamic> route(){

        return MaterialPageRoute(
            builder: (BuildContext context){
                return ListTaskPage();
            }
        );
    }

    const ListTaskPage();


    @override
    _ListTaskPageState createState() =>  _ListTaskPageState();
}

class  _ListTaskPageState extends State<ListTaskPage>{
    @override
    Widget build(BuildContext context){
        return Scaffold(
          floatingActionButton: FloatingActionButton(child: Icon(Icons.add_outlined),
            onPressed: () {  },),
          appBar: AppBar(
            title: Text("Danh sách nhiệm vụ"),
          ),
          body: ListView(children: [
            Column(children: [
              Text("Ngày 01-01-2021"),
              Text("Task1"),
              Text("Task2"),
            ],),
          ],),
        );
    }
}