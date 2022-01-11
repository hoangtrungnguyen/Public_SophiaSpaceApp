import 'package:flutter/material.dart';

class CreateDiaryNotePage extends StatefulWidget{
    static String nameRoute = "/CreateDiaryNotePage";

    static Route<dynamic> route(){
        return MaterialPageRoute(
            builder: (BuildContext context){
                return CreateDiaryNotePage();
            }
        );
    }
    @override
    _CreateDiaryNotePageState createState() =>  _CreateDiaryNotePageState();
}

class  _CreateDiaryNotePageState extends State<CreateDiaryNotePage>{
    @override
    Widget build(BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: Text("Một ngày của bạn")
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(onPressed: () {  },
          label:  Text("Hoàn thành")),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 20,
                    minLines: 5,
                    style: TextStyle(),
                  ),

                ],
              ),
            ),),
        );
    }
}

