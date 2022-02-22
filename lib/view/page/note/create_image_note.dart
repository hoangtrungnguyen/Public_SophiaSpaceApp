import 'package:flutter/material.dart';
import 'package:sophia_hub/constant/theme.dart';

class CreateNoteImage extends StatefulWidget {
  const CreateNoteImage({Key? key}) : super(key: key);

  @override
  _CreateNoteImageState createState() => _CreateNoteImageState();
}

class _CreateNoteImageState extends State<CreateNoteImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Material(
          shape: continuousRectangleBorder,
          child: TextButton(child: Icon(Icons.close_rounded), onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
          backgroundColor: Colors.transparent,
          elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundLinearGradient(context)
        ),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Tiêu đề",
              ),
              onChanged: (input) {

              },
            ),

          ],
        ),
      ),
    );
  }
}
