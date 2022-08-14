import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/screens/add_own_book_page.dart';
import 'package:tez_app/screens/update_own_book_page.dart';

import '../components/text_widget.dart';
import '../models/own_book_model.dart';
import '../models/own_book_view_model.dart';
import '../models/saved_book_model.dart';
import 'book_detail_page.dart';
import 'main_book_page.dart';
import 'menu_bar.dart';
import 'own_book_detail_page.dart';
import 'own_book_note_list_page.dart';

class OkunmusBookPage extends StatefulWidget {
  const OkunmusBookPage({ Key? key }) : super(key: key);

  @override
  State<OkunmusBookPage> createState() => _OkunmusBookPageState();
}

class _OkunmusBookPageState extends State<OkunmusBookPage> {
  List<OkunmusBook>? okunmusBookList;
  bool _isLoading = true;
  bool isFiltering=false;
  late List<OkunmusBook> filteredList;

  void getOkunmusBooksfromApi() async {
    Provider.of<OkunmusBookViewModel>(context, listen: false).getOkunmusBookList()!
    .then((value){
      setState(() {
        okunmusBookList = value;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOkunmusBooksfromApi();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var fullOkunmuslarList = okunmusBookList;
    return Scaffold(
      drawer: MyDrawer(),
        backgroundColor: Colors.grey.shade100,
        body: _isLoading ? const Center(
          child: CircularProgressIndicator(),
        ) : 
        Column(
          children: [
            Container(
            padding: const EdgeInsets.only(left: 20,top:75.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                height: height*0.12,
                width: width*0.7,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.3,
                    color: const Color(0xFF363f93)
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20)
                  ),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                  children: const [
                    Text('Okunmuş Kitaplar', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                     Text(' Kütüphanesi', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                  ]),
                )
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.home_outlined, color: Color(0xFF363f93)),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MainBookPage())),
                )
          ],
        ),
        ),
        Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
               child: 
                 TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Arama: Kitap Adı',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    onChanged: (query){
                      if(query.isNotEmpty){
                        isFiltering = true;
                        setState(() {
                          filteredList = fullOkunmuslarList!.where((book) => book.bookName.toLowerCase().contains(query.toLowerCase())).toList();
                        });
                      }else{
                        WidgetsBinding.instance.focusManager.primaryFocus!.unfocus();
                        setState(() {
                          isFiltering = false;
                        });
                      }
                    },
                  ),
             ),
             Flexible(
               child: Padding(
                 padding: const EdgeInsets.only(right:5.0,left: 5.0),
                 child: ListView.builder(
                   padding: EdgeInsets.zero,
                   reverse: true,
                   itemCount: isFiltering
                   ? filteredList.length
                   : fullOkunmuslarList!.length,
                   itemBuilder: (context, index){
                     var okunmusList = isFiltering ? filteredList : fullOkunmuslarList;
                     return GestureDetector(
                       onTap: (){
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OkunmusBookDetail(
                                  book: okunmusList![index],
                              ),
                            )
                          );
                       },
                       child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: height*0.32,
                          child: Stack(
                            children: [
                              Positioned(
                                    top: 35,
                                    // ignore: unnecessary_new
                                    child: new Material(
                                      elevation: 0.0,
                                      // ignore: unnecessary_new
                                      child: new Container(
                                        height: height * 0.23,
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
                                      child:  Container(
                                          height: height*0.25,
                                          width: width*0.38,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(okunmusList![index].photoUrl.toString())
                                                //image: NetworkImage('https://i.dr.com.tr/cache/500x400-0/originals/0000000061603-1.jpg'),
                                              )),
                                        ),
                                      
                                    ),
                                  ),
                                   Positioned(
                                    top: 45,
                                    left: width * 0.45,
                                    child: Container(
                                      height: height*0.21,
                                      width: width*0.4,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height*0.06,
                                              child: SingleChildScrollView(child: TextWidget(
                                                text: okunmusList[index].bookName,
                                                //text: 'Tehlikeli Oyunlar',
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            ),
                                            const SizedBox(height: 7),
                                            TextWidget(
                                              text: okunmusList[index].authorName,
                                              //text: "Author: Oğuz Atay",
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Icon(Icons.menu_book_sharp,
                                                    size: 20, color: Colors.grey),
                                                const SizedBox(width: 5),
                                                TextWidget(
                                                  color: Colors.grey,
                                                  text: 'Sayfa: ' +
                                                      okunmusList[index].pageNumber.toString()
                                                          .toString(),
                                                  fontSize: 13,
                                                ),
                                              ],
                                            ),
                                            
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Image.asset('assets/notes.png', width: 21,height: 21,),
                                                  color: const Color(0xFF06113C),
                                                  onPressed: () {
                                                    Navigator.push(context, 
                                                      MaterialPageRoute(builder: (context) => NoteList(book: okunmusList[index],))
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: ()  {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => UpdateOkunmusBookView(
                                                          book: okunmusList[index],
                                                        ),
                                                      )
                                                    );
                                                  }, 
                                                  icon: const Icon(Icons.edit, color: Colors.green,),
                                                ),
                                                
                                                IconButton(
                                                  onPressed: ()  {
                                                     setState(() {
                                                       Provider.of<OkunmusBookViewModel>(context,listen: false).deleteBook(okunmusList[index]);
                                                       Navigator.push(context,
                                                        MaterialPageRoute(builder: (context) => OkunmusBookPage()));
                                                     });
                                                  }, 
                                                  icon: const Icon(Icons.delete, color: Colors.red,),
                                                ),
                                              ],
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
                   }
                 )
               ),
             ),
             Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 IconButton(
                  iconSize: 35,
                  color: Color(0xFF363f93),
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddOkunmusBookView(getNew: getOkunmusBooksfromApi,)));
                  }, 
                  icon: Icon(Icons.add_circle)
            ),
               ],
             ),
             Divider(),
        ]
        )
        
        
    );
  }
}