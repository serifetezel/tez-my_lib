import 'package:cloud_firestore/cloud_firestore.dart';

import 'notes_model.dart';

class OkunacakBook{
  final String id;
  final String bookName;
  final String authorName;
  final String photoUrl;
  final Timestamp plannedDate;
  final int pageNumber;
  final String kullaniciid;

  OkunacakBook({ 
    required this.id,
    required this.bookName,
    required this.authorName,
    required this.photoUrl,
    required this.plannedDate,
    required this.pageNumber, 
    required this.kullaniciid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'bookName' : bookName,
      'authorName' : authorName,
      'photoUrl' : photoUrl,
      'plannedDate' : plannedDate,
      'pageNumber' : pageNumber,
      'kullaniciid' : kullaniciid,
    };
  }

  factory OkunacakBook.fromMap(Map map) {
    return OkunacakBook(
      id: map['id'],
      bookName: map['bookName'],
      authorName: map['authorName'],
      photoUrl: map['photoUrl'],
      plannedDate: map['plannedDate'],
      pageNumber: map['pageNumber'],
      kullaniciid: map['kullaniciid'],
    );
  }
}

class OkunmusBook{
  final String id;
  final String bookName;
  final String authorName;
  final String photoUrl;
  final Timestamp readDate;
  final int pageNumber;
  final String kullaniciid;
  final List<Notes> notes;

  OkunmusBook({
    required this.id, 
    required this.bookName, 
    required this.authorName, 
    required this.photoUrl, 
    required this.readDate, 
    required this.pageNumber, 
    required this.kullaniciid,
    required this.notes});

  Map<String, dynamic> toMap()  {

    List<Map<String,dynamic>> notes = this.notes.map((notes) => notes.toMap()).toList();

    return{
    'id' : id,
    'bookName' : bookName,
    'authorName' : authorName,
    'photoUrl' : photoUrl,
    'readDate' : readDate,
    'pageNumber' : pageNumber,
    'kullaniciid' : kullaniciid,
    'notes' : notes
    };
  }

  factory OkunmusBook.fromMap(Map map) {

  var notesListAsMap = map['notes'] as List;
    List<Notes> notes = notesListAsMap.map((notesAsMap) => Notes.fromMap(notesAsMap)).toList();
     return OkunmusBook(
      id: map['id'],
      bookName: map['bookName'],
      authorName: map['authorName'],
      photoUrl: map['photoUrl'],
      readDate: map['readDate'],
      pageNumber: map['pageNumber'],
      kullaniciid: map['kullaniciid'],
      notes: notes
    );
  }
}