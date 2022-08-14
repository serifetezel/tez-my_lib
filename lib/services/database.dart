// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tez_app/models/own_book_model.dart';
import 'package:tez_app/models/saved_book_model.dart';

class Database {
  final String? uid;
  Database({this.uid});
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection = FirebaseFirestore.instance
  .collection('users');
  Future updateUserData(String name, String email, String password) async{
    return await userCollection.doc(uid).set({
      'name' : name,
      'email' : email,
      'password' : password
    });
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>getBookListFromApi(String referencePath){
    return _firestore.collection(referencePath).snapshots();
  }

  Stream<QuerySnapshot>getNotListFromApi(String referencePath){
    return _firestore.collection(referencePath).snapshots();
  }

  Future<void> deleteDocument({String? referencePath, String? id}) async {
    await _firestore.collection(referencePath!).doc(id).delete();
  }

  Future<void> setOkunacakBookData(
    {required String collectionPath, Map<String, dynamic>? bookAsMap}
  ) async {
    await _firestore
      .collection(collectionPath)
      .doc(OkunacakBook.fromMap(bookAsMap!).id)
      .set(bookAsMap);
  }

  Future<void> setOkunmusBookData(
    {required String collectionPath, Map<String, dynamic>? bookAsMap}
  ) async {
    await _firestore
    .collection(collectionPath)
    .doc(OkunmusBook.fromMap(bookAsMap!).id)
    .set(bookAsMap);
  }

  Future<void> setSavedBookData(
    {required String collectionPath, Map<String, dynamic>? bookAsMap}
  ) async {
    await _firestore
      .collection(collectionPath)
      .doc(SavedBookInfo.fromMap(bookAsMap!).id)
      .set(bookAsMap);
  }
}