// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_is_empty, unnecessary_new, duplicate_ignore, sized_box_for_whitespace

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tez_app/components/text_widget.dart';
import 'package:tez_app/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:tez_app/screens/main_book_page.dart';
import 'book_detail_page.dart';

class SameRatingList extends StatefulWidget {
  final double searchTerm;
  final String title;
 
  SameRatingList( {Key? key,  required this.searchTerm,required  this.title});

  @override
  State<SameRatingList> createState() => _SameRatingListState();
}

class _SameRatingListState extends State<SameRatingList> {
  var searchRecommendList = <BookInfo>[];
   
  void getRecommendBooksfromApi() async {
    var response = await http.get(Uri.parse('http://192.168.1.57:5000/rating?rating=${widget.searchTerm}'));
    
    print('başarılı');
    setState(() {
      Iterable list = json.decode(response.body);
      searchRecommendList = list.map((model) => BookInfo.fromJson(model)).toList();
      print('başarıllı');
    });
   
  }
  
  @override
  void initState() {
    super.initState();
    getRecommendBooksfromApi();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      color: Colors.grey.shade50,
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.02),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  height: 105,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.3,
                      color: Color(0xFF363f93),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                    ),
                    color: Colors.grey.shade200
                  ),
                  child: 
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText('"${widget.title}" ', 
                        maxLines: 2,
                        minFontSize: 7,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 20,style: TextStyle(fontSize: 20, color: Color(0xFF363f93), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                        Text("Kitabına Verdiğiniz Puana", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: Color(0xFF363f93), fontStyle: FontStyle.italic, )),
                        Text("Benzer Puan Almış Kitaplar:", style: TextStyle(fontSize: 20, color: Color(0xFF363f93), fontStyle: FontStyle.italic, )),
                      ],
                   ),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.home_outlined, color: Color(0xFF363f93),size: 30,),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainBookPage())),
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: searchRecommendList.length == 0
                  ? CircularProgressIndicator()
                  : Column(
                      children: searchRecommendList.map((book) {
                        //debugPrint(article.image_url.toString());
                        return GestureDetector(
                          onTap: () {
                            
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailBookPage(
                                        bookInfo: book, index: 0)));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 250,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 35,
                                  // ignore: unnecessary_new
                                  child: new Material(
                                    elevation: 0.0,
                                    // ignore: unnecessary_new
                                    child: new Container(
                                      height: 180.0,
                                      width: width * 0.9,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          boxShadow: [
                                            // ignore: unnecessary_new
                                            new BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: new Offset(0.0, 0.0),
                                                blurRadius: 20.0,
                                                spreadRadius: 4.0)
                                          ]),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 10,
                                  child: Card(
                                    elevation: 10.0,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      height: 200,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                book.Image_link!),
                                            //image: NetworkImage('https://i.dr.com.tr/cache/500x400-0/originals/0000000061603-1.jpg'),
                                          )),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 45,
                                  left: width * 0.45,
                                  child: Container(
                                    height: 170,
                                    width: 150,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 73,
                                            child: SingleChildScrollView(child: TextWidget(
                                                text: book.Name,
                                                //text: 'Tehlikeli Oyunlar',
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          TextWidget(
                                            text: book.Author,
                                            //text: "Author: Oğuz Atay",
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.menu_book_sharp,
                                                  size: 20, color: Colors.grey),
                                              SizedBox(width: 5),
                                              TextWidget(
                                                color: Colors.grey,
                                                text: 'Rating: ' +
                                                    book.Rating
                                                        .toString(),
                                                fontSize: 13,
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          TextWidget(
                                            text: book.Description,
                                            //text: "'Tehlikeli Oyunlar' üstkurmaca ve bireyin kendisiyle hesaplaşması üzerine kurulu bir romandır. Atay'ın iki romanı da bir kara anlatı metnidir. Roman kahramanlarının 'tutunamayan' bireyler olmaları, toplum içerisinden kendilerini soyutlamaları ve yalnız bir hayat sürmeleri kara anlatının eserleridir.",
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          
          SizedBox(height: 5),
          Divider(color: Color(0xFF7b8ea3)),
          /*
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendAuthorList(searchTerm: widget.searchTerm )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          TextWidget(text: "Benzer Yazar Kitapları", fontSize: 20),
                          Expanded(child: Container()),
                          IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendAuthorList(searchTerm: widget.searchTerm )));}),
                        ],
                      ),
                    ),
                  ),
                ),
                */
                Divider(color: Color(0xFF7b8ea3)),
        ],
      )),
    ));
  }
}
