// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:tez_app/screens/menu_bar.dart';
import 'package:tez_app/screens/okunmus_book_pagee.dart';
import 'main_book_page.dart';
import 'okunacak_book_pagee.dart';

class MyLibrary extends StatefulWidget {
 
  @override
  _MyLibraryState createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: EdgeInsets.only(right:width/25,left:width/25,top:height/10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 30,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.home_outlined, color: Color(0xFF363f93)),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainBookPage())),
                  )
                ],
              ),
              SizedBox(height: height/8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ignore: prefer_const_constructors
                Text('MY LIBRARY', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                Divider(thickness: 3,),
                SizedBox(height: height/20,),
                Container(
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: [
                             CircleAvatar(
                              backgroundImage: 
                                AssetImage('assets/okunacaklar8.jpg'),
                                radius: 40,
                      ),
                      SizedBox(height: height/80,),
                            Container(
                              width: width/2.3,
                               child:  ElevatedButton(
                                 child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(' OKUNACAK ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text(' KİTAPLAR ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                 onPressed: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => OkunacakBookPage()));
                                 },
                                 style: ElevatedButton.styleFrom(
                                   fixedSize: const Size(50, 200),
                                   primary: Color(0xFF363f93)
                                 ),
                                 ),
                            ),
                          ],
                        ),
                        VerticalDivider(thickness: 3,),

                        Column(
                          children: [
                            //Image(image: AssetImage('assets/okunmuşlar2.jpg',),width: 150, height: 90,),
                            
                            CircleAvatar(
                              backgroundImage: 
                                AssetImage('assets/okunmuşlar.jpg',),
                                radius: 40,
                      ),
                      SizedBox(height: height/80),
                            Container(
                               width: width/2.3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(150, 200),
                                  primary: Color(0xFF363f93)//Colors.brown[300]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(' OKUNAN ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text(' KİTAPLAR ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OkunmusBookPage()));
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],

            ),
          ],
        ),
      )
    );
  }
}