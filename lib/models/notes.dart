class notes {
  int _id;
  String _title, _description, _date;

  notes(this._title, this._date, [this._description]);

  notes.withId(this._id, this._title, this._date, [this._description]);

  //getter methods
  get id => _id;

  get title => _title;

  get description => _description;

  get date => _date;

  //setter methods
  set title(String title) {
    _title = title;
  }

  set description(String description) {
    _description = description;
  }

  set date(String date) {
    _date = date;
  }

  //Convert to map object
  Map<String, dynamic> toMap() {
    Map<String, dynamic> myNote = Map<String, dynamic>();
    if(_id != null){
      myNote['id'] = _id;
    }
    myNote['title'] = _title;
    myNote['description'] = _description;
    myNote['date'] = _date;

    return myNote;
  }

  //Extracting notes from map object
  notes.fromMapObject(Map<String, dynamic> map){
    _id = map['id'];
    _title = map['title'];
    if(map['description'] != null) {
      _description = map['description'];
    }
    _date = map['date'];
  }

}
