import 'package:flutter/material.dart';
import 'package:new_notes_app/screens/edit_list.dart';
import 'package:new_notes_app/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: myList()
    );
  }
}
