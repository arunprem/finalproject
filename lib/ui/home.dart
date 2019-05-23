import 'package:finalproject/util/notodo_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("NoToDo"),
        backgroundColor: Colors.black54,
      ),
      body: new NotoDoScreen(),
    );
  }
}
