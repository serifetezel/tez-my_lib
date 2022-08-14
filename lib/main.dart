// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_import, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_app/models/own_book_model.dart';
import 'package:tez_app/models/own_book_view_model.dart';
import 'package:tez_app/models/user_model.dart';
import 'package:tez_app/screens/all_books_page.dart';
import 'package:tez_app/screens/all_popular_books_page.dart';
import 'package:tez_app/screens/main_book_page.dart';
import 'package:tez_app/screens/okunacak_book_page.dart';
import 'package:tez_app/screens/okunmus_book_page.dart';
import 'package:tez_app/screens/own_library.dart';
import 'package:tez_app/screens/same_rating_result_list_page.dart';
import 'package:tez_app/screens/search_page.dart';
import 'package:tez_app/screens/user_page.dart';
import 'package:tez_app/screens/welcome_sign_in_page.dart';
import 'package:tez_app/services/auth.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();
   var email = prefs.getString('email');
  await Firebase.initializeApp();
  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  final email;
  const MyApp({ Key? key, required this.email, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider(create: (BuildContext context)=>OkunacakBookViewModel(),),
        ChangeNotifierProvider(create: (BuildContext context)=>OkunmusBookViewModel(),),
        ChangeNotifierProvider(create: (BuildContext context)=>SavedBookViewModel(),),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('okunacak_kitaplar').snapshots()),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('okunmus_kitaplar').snapshots()),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('users').snapshots()),
        StreamProvider<QuerySnapshot?>(initialData: null,create: (_) => FirebaseFirestore.instance.collection('saved').snapshots()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Book Recommendation',
          theme: ThemeData(
            primaryColor: Colors.black,
          ),
          
          home:  WelcomePage()
        ),
      ),
    );
      
    
    /*
    MaterialApp(
      title: 'Book Recommendation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home:   Scaffold(body: Center(
          child: ElevatedButton(child: Text('tıkla'),onPressed: ()async{
                 print('sd');   
          var booksRef  = await FirebaseFirestore.instance
              .collection('okunacak_kitaplar')
              .where('kullaniciid',isEqualTo:'dv8LmQ2ZB2TqqeInrpGxKtcIEUc2')
              .get();
              print(booksRef.docs.length);
               booksRef.docs.forEach((doc) {
                print(doc['bookName']);
            });
          },),
          ),),
    );
    */
  }
}

