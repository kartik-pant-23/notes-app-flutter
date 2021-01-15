import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:new_notes_app/utils/database_helper.dart';
import 'package:new_notes_app/models/notes.dart';

class addNote extends StatefulWidget{

  notes chosenNote;

  addNote(this.chosenNote);

  @override
  State<StatefulWidget> createState() {
    return addNoteState(this.chosenNote);
  }
}

class addNoteState extends State<addNote>{

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  notes chosenNote;
  DatabaseHelper databaseHelper = DatabaseHelper();

  addNoteState(this.chosenNote);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    titleController.text = chosenNote.title;
    descriptionController.text = chosenNote.description;

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              moveBack();
            },
          ),
          title: Text('Edit note'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                child: TextField(
                  cursorColor: Colors.pinkAccent,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  controller: titleController,
                  onChanged: (value){
                    updateTitle();
                  },
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                child: TextField(
                  maxLines: null,
                  cursorColor: Colors.pinkAccent,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  controller: descriptionController,
                  onChanged: (value){
                    updateDescription();
                  },
                )),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: RaisedButton(
                              color: Colors.pinkAccent,
                              child: Text(
                                'SAVE',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _save();
                                });
                              })
                      )
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: RaisedButton(
                              color: Colors.pinkAccent,
                              child: Text(
                                'DELETE',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _delete();
                                });
                              })
                      )
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void updateTitle(){
    chosenNote.title = titleController.text;
  }

  void updateDescription() {
    chosenNote.description = descriptionController.text;
  }

  void _save() async {
    moveBack();
    chosenNote.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(chosenNote.id != null){
      result = await databaseHelper.updateNoteInDatabase(chosenNote);
    } else {
      result = await databaseHelper.insertIntoDatabase(chosenNote);
    }

    if(result!=0){
      _showAlertDialog('Status', 'Note saved successfully!');
    } else {
      _showAlertDialog('Status', 'Problem saving note!');
    }
  }

  void _delete() async{
    moveBack();
    if(chosenNote.id==null){
      _showAlertDialog('Status', 'No note was deleted!');
      return;
    }

    int result = await databaseHelper.deleteFromDatabase(chosenNote.id);
    if(result != 0){
      _showAlertDialog('Status', 'Note was successfully deleted!');
    } else {
      _showAlertDialog('Status', 'Error deleting the note!');
    }
  }

    void _showAlertDialog(String title, String message){
      AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
      );
      showDialog(
        context: context,
        builder: (_) => alertDialog
      );
    }

  void moveBack(){
    Navigator.pop(context, true);
  }
}