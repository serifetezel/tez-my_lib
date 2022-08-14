import 'package:cloud_firestore/cloud_firestore.dart';

class Notes{
  final String note;
  final String page;
  final Timestamp date;

  Notes({
    required this.note,
    required this.page,
    required this.date
  });

  Map<String, dynamic> toMap() => {
    'note' : note,
    'page' : page,
    'date' : date
  };

  factory Notes.fromMap(Map map) => Notes(
    note: map['note'], 
    page: map['page'], 
    date: map['date']
  );
}