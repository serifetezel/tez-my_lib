// ignore_for_file: unused_element, unnecessary_new, prefer_const_constructors, prefer_is_empty, duplicate_ignore, sized_box_for_whitespace, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures, avoid_print, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tez_app/screens/main_book_page.dart';
import 'package:tez_app/screens/search_result_list_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({ Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var myController = TextEditingController();
  var articles = [
    '"Hayatta korkmayacağınız tek şey doğru kitaptır."',
    '"Hiçbir gemi, bizi bir kitap kadar uzaklara götüremez." \n (Yunus Emre)',
    '"Kitaplar yaşadıkça  geçmiş  diye bir şey olmayacaktır." \n (Bulver Lytton)'
  ];
  final _totalDots = 3;
  double _currentPosition = 0.0;

  @override
  void initState(){
    super.initState();
  }

  double _validPosition(double position){
    if(position >= _totalDots)
      return 0;
    if(position < 0 )
      return _totalDots - 1.0;
    return position;
  }

  void _updatePosition(double position){
    setState(() => _currentPosition = _validPosition(position));
  }

  Widget _buildRow(List<Widget> widgets){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }

  String getCurrentPositionPretty() {
    return (_currentPosition + 1.0).toStringAsPrecision(2);
  }

  _onPageChanged(int index){
    setState(() {
      _currentPosition = _currentPosition.ceilToDouble();
      _updatePosition(index.toDouble());
      print(index);
      print(_currentPosition);
    });
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("HATA"),
          backgroundColor: Colors.red,
          content: new Text("Geçersiz Bir Kitap Girdiniz"),
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset('assets/walpaper.jpg').image,
        )
      ),
       child: Center(
          child: SingleChildScrollView(child: Column(
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only( top: height/12,left: width/45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainBookPage()));
                        }, icon: Icon(Icons.arrow_back))
                      ],
                    ),
                  ),
                  SingleChildScrollView(child: Container(
                height: height/9,
                child: PageView.builder(
                  onPageChanged: _onPageChanged,
                  controller: PageController(viewportFraction: 1.0),
                  itemCount: articles == null ? 0 : articles.length,
                  itemBuilder: (_, i){
                    return Container(
                      decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50)
                  ),
                ),
                      padding: EdgeInsets.only(top:height/50, left: width/9, right: width/9),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        articles[i] == null ? "Nothing " : articles[i],
                        style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Avenir", fontWeight: FontWeight.bold,),
                      ),
                    );
                  },
                ),
              ),
              ),
              _buildRow([
              DotsIndicator(
                dotsCount: _totalDots,
                position: _currentPosition,
                axis: Axis.horizontal,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),  
                ),
                onTap: (pos){
                  setState(() => _currentPosition = pos);
                },
              )
              ]),
              SizedBox(height: height/10),
              Padding(
                padding: const EdgeInsets.only(top:5.0,right: 15,left: 15,bottom: 200),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                    color: Colors.black38,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topLeft: Radius.circular(50)
                    ),
                    color: Colors.white.withOpacity(0.2),
                  ),
                    
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:SingleChildScrollView(child: Column(
                        children: [
                          Text('Kitap İçeriğine Bağlı \n Öneri Almak İçin ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 25,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.grey.shade300,
                            borderRadius:  BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: 'Kitap İsmi Giriniz',
                              suffixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height/20),
                      ElevatedButton(
                        onPressed: ()async{
                          var response = await http.get(Uri.parse('http://172.20.10.9:5000/book_title?title=\\\\\${myController.text}'));
                          jsonDecode(response.body).isEmpty
                          ? _showDialog()
                          : Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendList(searchTerm:myController.text)));
                        },
                        child: Text('Kitap Ara'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF363f93),
                          fixedSize: const Size(150,40),
                        ),
                      )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                  Row(
                    children: [
                      Container(child: Image.asset('assets/ünlem_gif.gif', ), height: 40,width: 40,),
                      SizedBox(width: 10,),
                      Expanded(child:Text('Kitap önerisi alabilmek için "Bütün Kitaplar" sayfasındaki herhangi bir kitap adını aratmalısınız.'))
                    ],),
                ],
              ),
          ),
        ),
      ),
    );
  }
}

