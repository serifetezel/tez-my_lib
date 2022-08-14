

import 'package:flutter/material.dart';

import '../services/database.dart';
import 'notes_model.dart';
import 'own_book_model.dart';

class OkunmusNotesListModel extends ChangeNotifier{
  Database _database = Database();
  String okunmusCollectionPath = 'okunmus_kitaplar';

  Future<void> updateNote({required List<Notes> noteList, OkunmusBook? book})async{
    OkunmusBook newOkunmusBook = OkunmusBook(
      id: book!.id,
      bookName: book.bookName,
      authorName: book.authorName,
      photoUrl: book.photoUrl,
      pageNumber: book.pageNumber,
      readDate: book.readDate,
      kullaniciid: book.kullaniciid,
      notes: noteList
    );
    await _database.setOkunmusBookData(
      collectionPath: okunmusCollectionPath, bookAsMap: newOkunmusBook.toMap());
  }

  Future<void> deleteNote(Notes book)async{
    await _database.deleteDocument(referencePath:  okunmusCollectionPath,);
  }
}