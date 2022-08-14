import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/api/data_api.dart';
import 'package:tez_app/components/text_widget.dart';
import 'package:tez_app/models/book_model.dart';
import 'package:tez_app/screens/all_popular_books_page.dart';
import 'package:tez_app/screens/book_detail_page.dart';
import 'package:tez_app/screens/menu_bar.dart';
import 'package:tez_app/screens/okunacak_book_pagee.dart';
import 'package:tez_app/screens/own_book_detail_page.dart';
import 'package:tez_app/screens/search_page.dart';
import '../models/own_book_model.dart';
import '../models/own_book_view_model.dart';

class MainBookPage extends StatefulWidget {
  const MainBookPage({ Key? key }) : super(key: key);

  @override
  _MainBookPageState createState() => _MainBookPageState();
}

class _MainBookPageState extends State<MainBookPage> {
  List<BookInfo> ?recommendBookList;
  List<OkunacakBook>? okuncakBookList;
   bool _isLoading = true;

  void getPopularBooksfromApi() async {
    PopularBooksApi.getPopularBooks().then((response){
      print(response);
      setState(() {
        Iterable list = json.decode(response.body);
        recommendBookList = list.map((model) => BookInfo.fromJson(model)).toList();
      });
    });
  }
  void getOkunacakBooksfromApi() async {
    Provider.of<OkunacakBookViewModel>(context, listen: false).getOkunacakBookList()!
    .then((value){
      setState(() {
        okuncakBookList = value;
        _isLoading = false;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    getPopularBooksfromApi();
    getOkunacakBooksfromApi();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    debugPrint(height.toString());
    return 
        Scaffold(
          backgroundColor: Colors.grey.shade50,//Colors.grey.shade50,
          appBar: AppBar(
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage( )));
                    }, 
                    icon: const Icon(Icons.search_sharp, color: Color(0xFF363f93))
                  )
                ],
              )
            ],
            toolbarHeight: height*0.04,
            backgroundColor: Colors.grey.shade50,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Color(0xFF363f93)),
          ),
          drawer: MyDrawer(),
          body: _isLoading?const Center(child: CircularProgressIndicator(),):
           Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left:50, right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                  ],
                                ),
                              ),
                              SizedBox(height: height*0.02),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: "Popüler", fontSize: 26,  color: const Color.fromARGB(255, 27, 38, 77)
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:14.0),
                                          child: TextWidget(
                                            text: "Olan Kitaplar...", fontSize: 26,  color: const Color.fromARGB(255, 27, 38, 77)
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Row(
                                      children: [
                                        TextButton(child: const Text( "view all",style: TextStyle( fontSize:16, color:Color(0xFFa9b3bd))), onPressed: (){Navigator.push(context,  MaterialPageRoute(builder: (context)=>const AllPopularBookPage()));},),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF363f93), size: 16),
                                          onPressed: (){
                                            Navigator.push(context,  MaterialPageRoute(builder: (context)=>const AllPopularBookPage())  
                                        );
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: height*0.001),
                              // ignore: sized_box_for_whitespace
                              Container(
                                height: height*0.31,
                                child: PageView.builder(
                                  controller: PageController(viewportFraction: .9),
                                  itemCount: recommendBookList == null ? 0 : 5,
                                  itemBuilder: (_, i){
                                    return GestureDetector(
                                      onTap: (){
                                        debugPrint(i.toString());
                                        Navigator.push(context, 
                                          MaterialPageRoute(builder: (context)=>DetailBookPage(bookInfo: recommendBookList![i], index: 0,))
                                        );
                                      },
                                      // ignore: prefer_is_empty
                                      child: recommendBookList!.length == 0 ? const CircularProgressIndicator() : Stack(
                                       
                                        children: [
                                          Positioned(
                                            top: 35,
                                            // ignore: unnecessary_new
                                            child: new Material(
                                              elevation: 0.0,
                                              // ignore: unnecessary_new
                                              child: new Container(
                                                height: height*0.25,
                                                width: width*0.85,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(0.0),
                                                  boxShadow: [
                                                    // ignore: unnecessary_new
                                                    new BoxShadow(
                                                      color: Colors.grey.withOpacity(0.3),
                                                      // ignore: prefer_const_constructors, unnecessary_new
                                                      offset: new Offset(-10.0, 0.0),
                                                      blurRadius: 20.0,
                                                      spreadRadius: 4.0
                                                    )
                                                  ]
                                                ),
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
                                                height: height*0.27,
                                                width: width*0.37,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(recommendBookList![i].Image_link.toString())
                                                  )
                                                ),
                                              ),
                                            )
                                          ),
                                          Positioned(
                                            top: height/16,
                                            left: width*0.45,
                                            child: SizedBox(
                                              height: height*0.23,
                                              width: width*0.37,
                                              child:
                                              SingleChildScrollView(
                                                child: 
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // ignore: sized_box_for_whitespace
                                                    Container(
                                                      height: height*0.08,
                                                      child: SingleChildScrollView(
                                                        child: TextWidget(
                                                          text: recommendBookList![i].Name,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Wrap(
                                                      children: [
                                                        const Icon(Icons.person, size: 20, color: Colors.grey),
                                                        TextWidget(
                                                          color: Colors.grey,
                                                          // ignore: prefer_if_null_operators
                                                          text: recommendBookList![i].Author == null ? "Dylan" : recommendBookList![i].Author,
                                                          fontSize: 16,
                                                        ),
                                                      ],
                                                    ),
                                                     SizedBox(height: height/90),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Icon(Icons.menu_book_sharp, size: 20, color: Colors.grey),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            const SizedBox(width: 5),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextWidget(
                                                                  color: Colors.grey,
                                                                  text: 'Rating: ',
                                                                  fontSize: 13,
                                                                ),
                                                                TextWidget(
                                                                  color: Colors.grey,
                                                                  text: recommendBookList![i].Rating.toString(),//'16'
                                                                  fontSize: 13,
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextWidget(
                                                                  color: Colors.grey,
                                                                  text: 'Tür: ',
                                                                  fontSize: 13,
                                                                ),
                                                                TextWidget(
                                                                  color: Colors.grey,
                                                                  text: recommendBookList![i].Genres.toString(),
                                                                  fontSize: 13,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      color: Colors.black,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.arrow_downward, size: 20,color: Colors.grey,),
                                                        const SizedBox(width: 10,),
                                                        TextWidget(text: "İçerik: ", color: Colors.grey, fontSize: 13,)
                                                      ],
                                                    ),
                                                    
                                                    TextWidget(
                                                      text: recommendBookList![i].Description,
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          text: "Okumayı", fontSize: 26,  color: const Color.fromARGB(255, 27, 38, 77)
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:14.0),
                                          child: TextWidget(
                                            text: "Düşündükleriniz..", fontSize: 26,  color: const Color.fromARGB(255, 27, 38, 77)
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    Row(
                                      children: [
                                        TextButton(child: const Text( "view all",style: TextStyle( fontSize:16, color:Color(0xFFa9b3bd))), onPressed: (){Navigator.push(context,  MaterialPageRoute(builder: (context)=> const OkunacakBookPage()));},),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF363f93), size: 16),
                                          onPressed: (){
                                            Navigator.push(context,  MaterialPageRoute(builder: (context)=>const OkunacakBookPage()));
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  // ignore: sized_box_for_whitespace
                                  child: Container(
                                    height: height*0.5,
                                    child: ListView.builder(
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: okuncakBookList == null ? 0 : okuncakBookList!.length,
                                      itemBuilder: (_, i){
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, 
                                              MaterialPageRoute(builder: (context) => OkunacakBookDetail(book: okuncakBookList![i], ))
                                            );
                                          },
                                          // ignore: prefer_is_empty
                                          child: okuncakBookList!.length == 0 ? const CircularProgressIndicator() : Container(
                                            height: height*0.001,
                                            width: width*0.37,
                                            margin: const EdgeInsets.only(left: 20),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Card(
                                                    semanticContainer: true,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    child: Image.network(okuncakBookList![i].photoUrl.toString(),
                                                    fit: BoxFit.fill
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    elevation: 5,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextWidget(
                                                    text: okuncakBookList![i].bookName, fontSize: 18,
                                                  ),
                                                  TextWidget(
                                                    text: okuncakBookList![i].authorName == null ? "Author: Dylon" : "Author: " + okuncakBookList![i].authorName.toString(), fontSize:16, color: const Color(0xFFa9b3bd)
                                                   
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },                
                                    ),
                                  ),
                                ),
                              )
                            ]
                            )
                          
        );
  }
}           