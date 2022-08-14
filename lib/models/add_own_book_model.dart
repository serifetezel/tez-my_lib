// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:tez_app/models/own_book_model.dart';
import 'package:tez_app/services/calculator.dart';
import 'package:tez_app/services/database.dart';

class AddOkunacakBookViewModel extends ChangeNotifier {
  Database _database = Database();
  String okunacakCollectionPath = 'okunacak_kitaplar';

  Future <void> addOkunacakNewBook (
    {
      required String bookName, 
      required String authorName,  
      photoUrl, 
      required DateTime plannedDate, 
      required int pageNumber, 
      required String kullaniciid
    }
  ) async {
    OkunacakBook newOkunacakBook = OkunacakBook(
      id: DateTime.now().toString(),
      bookName: bookName,
      authorName: authorName,
      photoUrl: photoUrl,
      pageNumber: pageNumber,
      plannedDate: Calculator.datetimeToTimestamp(plannedDate),
      kullaniciid: kullaniciid,

    );

    await _database.setOkunacakBookData(
      collectionPath: okunacakCollectionPath,
      bookAsMap: newOkunacakBook.toMap()
    );
  }
}

class AddOkunmusBookViewModel extends ChangeNotifier{
  Database _database = Database();
  String okunmusCollectionPath = 'okunmus_kitaplar';

  Future <void> addOkunmusNewBook (
    {
      required String bookName, 
      required String authorName, 
      photoUrl, 
      required DateTime readDate, 
      required int pageNumber, 
      required String kullaniciid
    }
  )async{
    OkunmusBook newOkunmusBook = OkunmusBook(
      id: DateTime.now().toString(), 
      bookName: bookName, 
      authorName: authorName, 
      photoUrl: photoUrl,
      readDate: Calculator.datetimeToTimestamp(readDate), 
      pageNumber: pageNumber, 
      kullaniciid: kullaniciid,
      notes: []
    );

    await _database.setOkunmusBookData(collectionPath: okunmusCollectionPath,
      bookAsMap: newOkunmusBook.toMap()
    );
  }
}