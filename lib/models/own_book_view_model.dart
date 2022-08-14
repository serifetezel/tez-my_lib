// ignore_for_file: prefer_final_fields, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tez_app/models/own_book_model.dart';
import 'package:tez_app/models/saved_book_model.dart';
import 'package:tez_app/services/database.dart';

class OkunacakBookViewModel extends ChangeNotifier{
  String _okunacakCollectionPath = 'okunacak_kitaplar';

  Database _database = Database();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<List<OkunacakBook>>? getOkunacakBookList()async {
    List<OkunacakBook> streamListBook = [];
    var booksRef  = await FirebaseFirestore.instance
              .collection('okunacak_kitaplar')
              .where('kullaniciid',isEqualTo:auth.currentUser!.uid)
              .get();
               booksRef.docs.forEach((doc) {
                OkunacakBook oku = OkunacakBook.fromMap(doc.data());
                 streamListBook.add(oku);
            });
        return streamListBook;
    // Query<Map<String, dynamic>> booksRef  = FirebaseFirestore.instance
    //   .collection('okunacak_kitaplar')
    //   .where("kullaniciid", isEqualTo: auth.currentUser!.uid);
     
    // Stream<List<DocumentSnapshot>> streamListDocument = _database
    //   .getBookListFromApi(booksRef.toString())
    //   .map((querySnapshot) => querySnapshot.docs) ;
    //   debugPrint('error:'+booksRef.toString());
    //   Stream<List<OkunacakBook>> streamListBook = 
    //     streamListDocument.map((listOfDocSnap) => listOfDocSnap.map((docSnap) => OkunacakBook.fromMap(docSnap.data()!/*.where('kullaniciid', isEqualTo: auth.currentUser!.uid)*/ as Map<String,dynamic>)).toList());
    //   return streamListBook;
  }
  Future<void> deleteBook(OkunacakBook book) async {
    await _database.deleteDocument(referencePath: _okunacakCollectionPath, id: book.id);
  }
}

class OkunmusBookViewModel extends ChangeNotifier{
  String _okunmusCollectionPath = 'okunmus_kitaplar';

  Database _database = Database();

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<List<OkunmusBook>>? getOkunmusBookList() async {
    List<OkunmusBook> streamListBook = [];
    var booksRef = await FirebaseFirestore.instance
              .collection('okunmus_kitaplar')
              .where('kullaniciid', isEqualTo: auth.currentUser!.uid)
              .get();
              booksRef.docs.forEach((doc) {
                OkunmusBook oku = OkunmusBook.fromMap(doc.data());
                  streamListBook.add(oku);
              });
              return streamListBook;
  }

  // Stream <List<OkunmusBook>>? getOkunmusBookList(){
  //   const String booksRef = 'okunmus_kitaplar';
  //   Stream<List<DocumentSnapshot>> streamListDocument = _database
  //   .getBookListFromApi(booksRef)
  //   .map((querySnapshot) => querySnapshot.docs);
  //   Stream<List<OkunmusBook>> streamListBook = 
  //     streamListDocument.map((listOfDocSnap) => listOfDocSnap.map((docSnap) => OkunmusBook.fromMap(docSnap.data() as Map<String, dynamic>)).toList());
  //   return streamListBook;
  // } 
  Future<void> deleteBook(OkunmusBook book)async{
    await _database.deleteDocument(referencePath: _okunmusCollectionPath, id: book.id);
  }
}

class SavedBookViewModel extends ChangeNotifier{
    String _savedCollectionPath = 'saved';
    Database _database = Database();
    FirebaseAuth auth = FirebaseAuth.instance;
    Future<List<SavedBookInfo>>? getSavedBookList() async {
      List<SavedBookInfo> streamListBook = [];
      var booksRef = await FirebaseFirestore.instance
        .collection(_savedCollectionPath)
        .where('kullaniciid', isEqualTo: auth.currentUser!.uid)
        .get();
        booksRef.docs.forEach((doc) {
          SavedBookInfo save = SavedBookInfo.fromMap(doc.data());
          streamListBook.add(save);
        });
        return streamListBook;
    }
    Future<void> deleteBook(SavedBookInfo book)async{
    await _database.deleteDocument(
      referencePath: _savedCollectionPath, 
      id: book.id);
    }
  }