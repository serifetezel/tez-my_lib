
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_app/models/user_model.dart' as users;
import 'package:tez_app/screens/all_books_page.dart';
import 'package:tez_app/screens/all_popular_books_page.dart';
import 'package:tez_app/screens/main_book_page.dart';
import 'package:tez_app/screens/own_library.dart';
import 'package:tez_app/screens/saved.dart';
import 'package:tez_app/screens/saved_book_page(-).dart';
import 'package:tez_app/screens/search_page.dart';
import 'package:tez_app/screens/user_page.dart';
import 'package:tez_app/screens/welcome_sign_in_page.dart';
import 'package:tez_app/models/user_model.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade50,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.menu_book_sharp,
                    color: Colors.white,
                    size: 95.0,
                  ),
                  Text(
                    "KİTAP ÖNERİ UYGULAMASI",
                    style: TextStyle(color: Colors.white, fontSize: 21.0),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF363f93),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Color(0xFF7b8ea3)),
            title: Text('Anasayfa'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => MainBookPage())
                        );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.book, color: Color(0xFF7b8ea3)),
            title: Text('Tüm Kitaplar'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => AllBookPage())
              );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.bookmark, color: Color(0xFF7b8ea3)),
            title: Text('Kaydedilen Kitaplar'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Save())
              );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.star, color: Color(0xFF7b8ea3)),
            title: Text('Popüler Kitaplar'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => AllPopularBookPage())
              );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.search, color: Color(0xFF7b8ea3)),
            title: Text('Öneri için Kitap Ara'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => SearchPage())
              );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.local_library, color: Color(0xFF7b8ea3)),
            title: Text('Kitaplığım'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => MyLibrary())
              );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFF7b8ea3)),
            title: Text('Kullanıcı Sayfası'),
            trailing: Icon(Icons.arrow_right),
            
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ProfilePage())
              );
            },
          ),
          Divider(thickness: 1,),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Color(0xFF7b8ea3)),
            title: Text('Çıkış Yap'),
            onTap: ()async{
              SharedPreferences localStorage = await SharedPreferences.getInstance();
              localStorage.remove('user');
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => WelcomePage())
              );
            },
          ),
        ],
      ),
    );
  }
}
