import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:new_notes_app/models/notes.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  //Database values
  String tableName = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Initialize database
  Future<Database> initializeDatabase() async{
    //Get directory path for both android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String pathName = directory.path + 'notes.db';
    Database noteDatabase = await openDatabase(pathName, version: 1, onCreate: _createDb);
    return noteDatabase;
  }

  //Creates new database
  _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colDescription TEXT, $colDate TEXT)');
  }

  //Fetch data from database
  Future<List<Map<String, dynamic>>> getNoteFromDatabase() async{
    Database database = await this.database;
    var result = await database.rawQuery('SELECT * FROM $tableName');
    return result;
  }

  //Insert a note into database
  Future<int> insertIntoDatabase(notes note) async {
    Database database = await this.database;
    var result = await database.insert(tableName, note.toMap());
    return result;
  }

  //Delete a note from database
  Future<int> deleteFromDatabase(int id) async {
    Database database = await this.database;
    var result = await database.delete(tableName, where: '$colId = $id');
    return result;
  }

  //Update a note in database
  Future<int> updateNoteInDatabase(notes note) async {
    Database database = await this.database;
    var result = database.update(tableName, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //Get number of notes in database
  Future<int> getNumberOfNotes() async {
    Database database = await this.database;
    var x = await database.rawQuery('SELECT COUNT (*) FROM $tableName');
    var result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get list of notes
  Future<List<notes>> getNotesList() async{
    var mapListNotes = await getNoteFromDatabase();
    List<notes> myNotes = List<notes>();
    for(int i=0;i<mapListNotes.length;i++){
      myNotes.add(notes.fromMapObject(mapListNotes[i]));
    }
    return myNotes;
  }
}