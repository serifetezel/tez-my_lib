// ignore_for_file: unnecessary_this, prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, sized_box_for_whitespace, prefer_const_declarations, avoid_print, unused_element, unnecessary_new, use_key_in_widget_constructors
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/components/text_widget.dart';
import 'package:tez_app/models/book_model.dart';
import 'package:tez_app/models/saved_book_model.dart';
import 'package:tez_app/screens/benzer_yazar_kitaplari.dart';
import 'package:tez_app/screens/main_book_page.dart';
import 'package:http/http.dart' as http;
import 'package:tez_app/screens/same_rating_result_list_page.dart';
import 'package:tez_app/screens/saved.dart';

import '../models/own_book_view_model.dart';

class SavedBookDetail extends StatefulWidget {
  final SavedBookInfo book;
  const SavedBookDetail({required this.book});

  @override
  State<SavedBookDetail> createState() => _SavedBookDetailState();
}

class _SavedBookDetailState extends State<SavedBookDetail> {
  TextEditingController notController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var articles = <BookInfo>[];
  bool isLiked = true;
  int likeCount = 0;
  bool isRecommend = false;

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("HATA"),
          backgroundColor: Colors.red,
          content: new Text("Geçersiz Bir Puanlama Girdiniz"),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double size = 30;
    return Container(
      color: Colors.grey.shade50,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
         
          body: Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.only(left: 20, top:15),
            child: SingleChildScrollView(child: 
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 0, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: Row(
                    children: [
                      Material(
                        elevation: 0.0,
                        child: Container(
                          height: height*0.25,
                          width: width*0.37,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3)
                              )
                            ],
                            image: DecorationImage(
                              image: NetworkImage(widget.book.Image_link ?? "https://i.dr.com.tr/cache/500x400-0/originals/0000000061603-1.jpg") ,
                              fit: BoxFit.fill
                            )
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth-30-180-20,
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: height*0.12, 
                              child:SingleChildScrollView(
                                child: TextWidget(text: this.widget.book.Name, fontSize: 26))),
                            SizedBox(height: 10),
                            TextWidget(text: this.widget.book.Author,fontSize: 20,color: Color(0xFF7b8ea3)),
                            Divider(color: Colors.grey),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.rate_review, color: Color(0xFF7b8ea3)),
                                TextWidget(text: this.widget.book.Rating.toString(), fontSize: 16, color: Color(0xFF7b8ea3)),
                              
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.menu_book_sharp, color: Color(0xFF7b8ea3)),
                                SizedBox(width: 5),
                                TextWidget(text: this.widget.book.Genres.toString(), fontSize: 16, color: Color(0xFF7b8ea3)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Color(0xFF7b8ea3)),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          LikeButton(
                            size: size,
                            isLiked: isLiked,
                            likeCount: likeCount.toInt(),
                            likeBuilder: (isLiked){
                              isLiked = !isLiked;
                              final color = isLiked ? Colors.red : Color(0xFF7b8ea3);
                              return Icon(Icons.favorite, color: color,size: size);
                            },
                            likeCountPadding: EdgeInsets.only(left: 12),
                            countBuilder: (count, isLiked, text){
                              final color = isLiked ? Colors.black : Colors.grey;
                              return Text(
                                text,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              );
                            },
                            onTap: (isLiked) async {
                              this.isLiked = !isLiked; 
                              likeCount += this.isLiked ? 1 : -1;
                              return !isLiked;
                            },
                          ),
                          
                      SizedBox(width: 35),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LikeButton(
                            size: size,
                            isLiked: isLiked,
                            likeBuilder: (isLiked) {
                              isLiked = !isLiked;
                              final color = isLiked ? Color(0xFF363f93) : Color(0xFF7b8ea3);
                              return Icon(Icons.star, color: color, size: size);
                            },
                            likeCountPadding: EdgeInsets.only(left:12),
                            countBuilder: (count, isLiked, text) {
                              final color = isLiked ? Color(0xFF363f93) : Color(0xFF7b8ea3);
                              return Text(text,style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold));
                            },
                            onTap: (isLiked) async {
                              new Future.delayed(Duration(minutes: 1));
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    content: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                minRadius: 8,
                                                maxRadius: 15,
                                                child: Icon(Icons.close),
                                                backgroundColor: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('1-5 arasında puanlayarak aynı puan değerinde farklı kitaplar listesini görüntüleyebilirsiniz.'),
                                        SizedBox(height: 10),
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: notController,
                                                keyboardType: TextInputType.number,
                                                maxLines: 1,
                                                minLines: 1,
                                                decoration: InputDecoration(
                                                  hintText: 'Puanla:',hintStyle: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20),
                                                  icon: Icon(Icons.star,color: Color(0xFF7b8ea3),size: 30)
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: Color(0xFF06113C)),
                                                      child: Text('Önerileri Gör'),
                                                      onPressed: ()async{
                                                        double notControllerDouble = double.parse(notController.text);
                                                        print(notControllerDouble);
                                                        var response = await http.get(Uri.parse('http://172.20.10.9:5000/rating?rating=$notControllerDouble'));
                                                        
                                                        jsonDecode(response.body).isEmpty
                                                        ? debugPrint('Hata')
                                                        : Navigator.push(context, MaterialPageRoute(builder: (context) => SameRatingList(searchTerm: double.parse(notController.text), title: this.widget.book.Name.toString())));
                                                      debugPrint('başarılı');
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              );
                              return !isLiked;
                            },
                            ),
                          TextButton(child: TextWidget(text: "Puanla",color: Color(0xFF7b8ea3),fontSize: 20), 
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    content: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                minRadius: 8,
                                                maxRadius: 15,
                                                child: Icon(Icons.close),
                                                backgroundColor: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('1-5 arasında puanlayarak aynı puan değerinde farklı kitaplar listesini görüntüleyebilirsiniz.'),
                                        SizedBox(height: 10),
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: notController,
                                                keyboardType: TextInputType.number,
                                                maxLines: 1,
                                                minLines: 1,
                                                decoration: InputDecoration(
                                                  hintText: 'Puanla:',hintStyle: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20),
                                                  icon: Icon(Icons.star,color: Color(0xFF7b8ea3),size: 30)
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: Color(0xFF06113C)),
                                                      child: Text('Önerileri Gör'),
                                                      onPressed: ()async{
                                                        double notControllerDouble = double.parse(notController.text);
                                                        print(notControllerDouble);
                                                        var response = await http.get(Uri.parse('http://172.20.10.9:5000/rating?rating=$notControllerDouble'));
                                                        
                                                        jsonDecode(response.body).isEmpty
                                                        ? debugPrint('Hata')
                                                        : Navigator.push(context, MaterialPageRoute(builder: (context) => SameRatingList(searchTerm: double.parse(notController.text), title: this.widget.book.Name.toString())));
                                                      debugPrint('başarılı');
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              );
                          })
                        ],
                      ),
                        ],
                      ),
                      SizedBox(width: 20,),
                          Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LikeButton(
                              size: size,
                              isLiked: isLiked,
                              likeBuilder: (isLiked) {
                                final color = isLiked ? Colors.black : Color(0xFF7b8ea3);
                                return Icon(Icons.bookmark, color: color, size: size);
                              },
                            likeCountPadding: EdgeInsets.only(left: 12),
                            countBuilder: (count, isLiked, text){
                              final color = isLiked ? Colors.black : Colors.grey;
                              
                              return Text(text,style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold));
                            },
                            onTap: (isLiked) async {
                              this.isLiked = !isLiked;
                              
                              await Provider.of<SavedBookViewModel>(context,listen: false).deleteBook(this.widget.book);
                                Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Save()));
                            

                              return !isLiked;
                            },
                          ),
                          Text('Kaydet',style: TextStyle(
                                  color: Color(0xFF7b8ea3),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),)
                        ],
                      ),
                        ],
                      ),
                  ),
                SizedBox(height: 15),
                Row(
                  children: [
                    TextWidget(text: "Description: ", fontSize: 28),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  height: height*0.265,
                  child: SingleChildScrollView(child: Padding(
                    padding: const EdgeInsets.only(right:5.0),
                    child:TextWidget(text: this.widget.book.Description, fontSize: 16, color: Colors.grey),
                  )),
                ),
                SizedBox(height: 10,),
                Divider(color: Color(0xFF7b8ea3)),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainBookPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 20,bottom: 10),
                    child: Row(
                      children: [
                        TextButton(child:Text( "Benzer Yazar Kitapları", style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Avenir",fontWeight: FontWeight.w900,)), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendAuthorList(searchTerm:  this.widget.book.Name.toString())));},),
                        Expanded(child: Container()),
                        IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendAuthorList(searchTerm:  this.widget.book.Name.toString() )));}),
                      ],
                    ),
                  ),
                ),
                Divider(color: Color(0xFF7b8ea3)),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}

