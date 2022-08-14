// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';
import '../services/calculator.dart';
import '../services/database.dart';
import 'own_book_model.dart';

class UpdateOkunacakBookViewModel extends ChangeNotifier{
  Database _database = Database();
  String okunacakCollectionPath = 'okunacak_kitaplar';

  Future <void> updateOkunacakBook (
    {
      required String kullaniciid, 
      required String bookName, 
      required String authorName, 
      photoUrl,
      required DateTime plannedDate,  
      required int pageNumber, 
      required OkunacakBook book
    }
  ) async {
   
    OkunacakBook newOkunacakBook = OkunacakBook(
      id: book.id,
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

class UpdateOkunmusBookViewModel extends ChangeNotifier{
  Database _database = Database();
  String okunmusCollectionPath = 'okunmus_kitaplar';

  Future <void> updateOkunmusBook (
    {
      required String kullaniciid, 
      required String bookName, 
      required String authorName, 
      photoUrl, 
      required DateTime readDate, 
      required int pageNumber, 
      required OkunmusBook book
    }
  ) async {
    OkunmusBook newOkunmusBook = OkunmusBook(
      id: book.id, 
      bookName: bookName, 
      authorName: authorName, 
      photoUrl: photoUrl,
      readDate: Calculator.datetimeToTimestamp(readDate), 
      pageNumber: pageNumber, 
      kullaniciid: kullaniciid,
      notes: book.notes
    );

    await _database.setOkunmusBookData(collectionPath: okunmusCollectionPath,
      bookAsMap: newOkunmusBook.toMap()
    );
  }
}