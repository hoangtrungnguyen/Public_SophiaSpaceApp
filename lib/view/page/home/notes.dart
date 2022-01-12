import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/provider/data_provider.dart';

class NotesView extends StatefulWidget {
  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.center,
      child: Consumer<AppData>(builder: (ctx, data, child) {
        return ListView(
          children: data.listData.map((e) {
            List<Widget> notes = [
              Text(
                "Thời gian: ${e.time.day}-${e.time.month}-${e.time.year}",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 20,)
            ];
            notes.addAll(e.diaryNotes
                .map((e) => Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        Text(e.title ?? "null",
                            style: Theme.of(context).textTheme.headline6),
                        Text(e.description ?? "null")
                      ],
                    ))
                .toList());
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.blue[100],
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notes,
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
