import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/screens/saved_book_detail.dart';
import '../components/text_widget.dart';
import '../models/own_book_view_model.dart';
import '../models/saved_book_model.dart';
import 'main_book_page.dart';
import 'menu_bar.dart';

class Save extends StatefulWidget {
  const Save({ Key? key }) : super(key: key);

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
  List<SavedBookInfo>? savedBookList;
  bool _isLoading = true;
  bool isFiltering=false;
  late List<SavedBookInfo> filteredList;

  void getSavedBooksfromApi() async {
    Provider.of<SavedBookViewModel>(context, listen: false).getSavedBookList()!
    .then((value){
      setState(() {
        savedBookList = value;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getSavedBooksfromApi();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var fullSavedList = savedBookList;
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
                    Text('Kaydedilen Kitaplar', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                     Text(' Listesi', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
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
                          filteredList = fullSavedList!.where((book) => book.Name!.toLowerCase().contains(query.toLowerCase())).toList();
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
                   itemCount: isFiltering
                   ? filteredList.length
                   : fullSavedList!.length,
                   itemBuilder: (context, index){
                     var savedList = isFiltering ? filteredList : fullSavedList;
                     return GestureDetector(
                              onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SavedBookDetail(book: savedList![index])));
                              },
                              child:
                     Container(
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
                                                offset:  const Offset(0.0, 0.0),
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
                                              image: NetworkImage(savedList![index].Image_link.toString())
                                              )),
                                      ),
                                    
                                  ),
                                ),
                                 Positioned(
                                  top: 45,
                                  left: width * 0.45,
                                  child: SizedBox(
                                    height: height*0.21,
                                    width: width*0.4,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: height*0.09,
                                            child: SingleChildScrollView(child: TextWidget(
                                              text: savedList[index].Name.toString(),
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          ),
                                          const SizedBox(height: 7),
                                          TextWidget(
                                            text: savedList[index].Author.toString(),
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
                                                text: 'Rating: ' +
                                                    savedList[index].Rating.toString()
                                                        .toString(),
                                                fontSize: 13,
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            color: Colors.black,
                                          ),
                                          TextWidget(
                                            text: savedList[index].Description.toString(),
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
                     )
                     );
                   }
                 )
               ),
             )
        ]
        )
    );
  }
}