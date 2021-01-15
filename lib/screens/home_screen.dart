import 'package:flutter/material.dart';
import 'package:new_notes_app/screens/edit_list.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:new_notes_app/utils/database_helper.dart';
import 'package:new_notes_app/models/notes.dart';

class myList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return myListState();
  }
}

class myListState extends State<myList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<notes> notesList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(notesList==null){
      notesList = List<notes>();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      body: ListView.builder(
        cacheExtent: 7,
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 1.0,
            margin: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(notesList[position].title, style: Theme.of(context).textTheme.title),
              subtitle: Text(notesList[position].date, style: Theme.of(context).textTheme.subtitle),
              contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
              leading: CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.green,
                child: Icon(Icons.check,
                  color: Colors.white,),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.blueGrey,),
                onPressed: (){
                  _delete(context, notesList[position]);
                },
              ),
              onTap: (){
                switchAddNote(notesList[position]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add note',
        child: Icon(Icons.add),
        onPressed: (){
          switchAddNote(notes('',''));
        },
      ),
    );
  }

  void _delete(BuildContext context, notes note) async{
    notes cachedNote = note;
    int result = await databaseHelper.deleteFromDatabase(note.id);
    if(result != 0){
      //Note successfully deleted
      _showSnackbar(context, cachedNote, 'Note successfully deleted!');
      _updateListView();
    }
  }

  void _showSnackbar(BuildContext context, notes note, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'UNDO',
        textColor: Colors.blue,
        onPressed: () async {
          await databaseHelper.insertIntoDatabase(note);
          _updateListView();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void switchAddNote(notes chosenNote) async{
    bool result = await Navigator.push(context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){

            animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

            return ScaleTransition(
              alignment: Alignment.center ,
              scale: animation,
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
            return addNote(chosenNote);
          }
        ));
    if(result){
      _updateListView();
    }
  }

  void _updateListView() async{
    Future<Database> db = databaseHelper.initializeDatabase();
    db.then((database){
      Future<List<notes>> notesList = databaseHelper.getNotesList();
      notesList.then((notesList){
        setState(() {
          this.notesList = notesList;
          this.count = notesList.length;
        });
      });
    });
  }
}
