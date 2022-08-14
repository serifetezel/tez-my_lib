// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/models/own_book_view_model.dart';
import 'package:tez_app/models/saved_book_model.dart';
import 'package:tez_app/screens/main_book_page.dart';
import 'package:tez_app/screens/menu_bar.dart';

class SavedBookPage extends StatefulWidget {

  @override
  _SavedBookPageState createState() => _SavedBookPageState();
}

class _SavedBookPageState extends State<SavedBookPage> {
  
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
    print(savedBookList![1].Author.toString());
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
                      hintText: 'Arama: Kitap Adııııııııııııııııııııı',
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
                 child: 
                 ListView.builder(
                   itemCount: isFiltering
                   ? filteredList.length
                   : fullSavedList!.length,
                   itemBuilder: (context, index){
                     var savedList = isFiltering ? filteredList : fullSavedList;
                     print(savedList![0].Author);
                     return Slidable(
                      child:  
                      Card(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 7,
                        color: const Color(0xFFD9D7F1),
                        //Color(0xFFA7BBC7),//Color(0xFFD9D7F1),//Color(0xFFCCD1E4),//
                        
                        child: GestureDetector(
                          onDoubleTap: () {} ,
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxHeight: 64,
                                maxWidth: 64
                              ),
                              child: Image(image: NetworkImage(savedList[index].Image_link.toString()),fit: BoxFit.cover,)),
                            title: Text(savedList[index].Name.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(width: 10,),
                                      Text(savedList[index].Author.toString(), style: const TextStyle(fontSize: 15),),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.menu_book_sharp),
                                      SizedBox(width: 10,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(
                          onDismissed: (){},
                        ),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.black45,
                            onPressed: (_){},
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          
                          SlidableAction(
                            backgroundColor: Colors.red,
                            onPressed: (_)async{},
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      )
                    );
                   },
                 ),
              ),
            ),
                // StreamBuilder<List<OkunacakBook>>(
                //   stream: Provider.of<OkunacakBookViewModel>(context, listen: false).getOkunacakBookList()!,
                //   builder: (context, asyncSnapshot) {
                //     print(asyncSnapshot.error);
                //     if(asyncSnapshot.hasError) {
                //       // ignore: prefer_const_constructors
                //       return Center (
                //         child: Text('Bir hata oluştu, daha sonra tekrar deneyiniz.'),
                //       );
                //     } else {
                //       if(!asyncSnapshot.hasData){
                //         return CircularProgressIndicator();
                //       }else{
                //         List<OkunacakBook> kitapList = asyncSnapshot.data!;
                //         return BuildOkunacaklarView(kitapList: kitapList);
                //       }
                //     }
                //   }
                // ),
                const Divider(),
              ],
            ),
    );
  }
}

// class BuildOkunacaklarView extends StatefulWidget {
//   const BuildOkunacaklarView({ Key? key, required this.kitapList }) : super(key: key);

//   final List<OkunacakBook> kitapList;
//   @override
//   _BuildOkunacaklarViewState createState() => _BuildOkunacaklarViewState();
// }

// class _BuildOkunacaklarViewState extends State<BuildOkunacaklarView> {
//   bool isFiltering=false;
//   late List<OkunacakBook> filteredList;
  
//   @override
//   Widget build(BuildContext context) {
//     var fullOkunacaklarList = widget.kitapList;
//     return Flexible(
//       child:  Column(
//           children: [
//             Container(
//             padding: const EdgeInsets.only(left: 20,top:75.0, right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   constraints: BoxConstraints(),
//                   icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 Container(
//                 height: 90,
//                 width: 250,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 1.3,
//                     color: Color(0xFF363f93)
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(20),
//                     topLeft: Radius.circular(20)
//                   ),
//                   color: Colors.grey.shade200,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                   children: [
//                     Text('Okunacak Kitaplar', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
//                      Text(' Kütüphanesi', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
//                   ]),
//               )),
                
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   iconSize: 30,
//                   constraints: BoxConstraints(),
//                   icon: Icon(Icons.home_outlined, color: Color(0xFF363f93)),
//                   onPressed: () => Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => MainBookPage())),
//                 )
//               ],
//             ),
//           ),
            
//              Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
//                child: 
//                  TextField(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search),
//                       hintText: 'Arama: Kitap Adı',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(6.0),
//                       ),
//                     ),
//                     onChanged: (query){
//                       if(query.isNotEmpty){
//                         isFiltering = true;
//                         setState(() {
//                           filteredList = fullOkunacaklarList.where((book) => book.bookName.toLowerCase().contains(query.toLowerCase())).toList();
//                         });
//                       }else{
//                         WidgetsBinding.instance.focusManager.primaryFocus!.unfocus();
//                         setState(() {
//                           isFiltering = false;
//                         });
//                       }
//                     },
//                   ),
//              ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(right:5.0,left: 5.0),
//                 child: Expanded(
//                   child: ListView.builder(
//                     itemCount: isFiltering
//                     ? filteredList.length
//                     : fullOkunacaklarList.length,
//                     itemBuilder: (context, index){
//                       var okunacakList = isFiltering ? filteredList : fullOkunacaklarList;
//                       //FirebaseStorage _storage= FirebaseStorage.instance;
//                       //Reference refPhotos = _storage.ref().child('bookPhotos');
//                       //var photoUrl = refPhotos.child('insanınmerakyolculuğu.jpg').getDownloadURL();
                      
//                       return Slidable(
//                         child: Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top:5.0, bottom: 5),
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               elevation: 7,
//                               color: Color(0xFFD9D7F1),//Color(0xFFA7BBC7),//Color(0xFFD9D7F1),//Color(0xFFCCD1E4),//
                              
//                               child: GestureDetector(
//                                 onDoubleTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => OkunacakBookDetail(
//                                            book: okunacakList[index],
//                                         ),
//                                       )
//                                     );
//                                   } ,
//                                 child: ListTile(
//                                   leading: ConstrainedBox(
//                                     constraints: BoxConstraints(
//                                       minWidth: 44,
//                                       minHeight: 44,
//                                       maxHeight: 64,
//                                       maxWidth: 64
//                                     ),
//                                     child: Image(image: NetworkImage(fullOkunacaklarList[index].photoUrl),fit: BoxFit.cover,)),
//                                   //leading: Image(image: AssetImage('assets/bookk.gif'),),
//                                   title: Text(okunacakList[index].bookName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                  
//                                   subtitle: Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(Icons.person),
//                                             SizedBox(width: 10,),
//                                             Text(okunacakList[index].authorName, style: TextStyle(fontSize: 15),),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.menu_book_sharp),
//                                             SizedBox(width: 10,),
//                                             Text(okunacakList[index].pageNumber.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         endActionPane: ActionPane(
//                           motion: const ScrollMotion(),
//                           dismissible: DismissiblePane(
//                             onDismissed: (){},
//                           ),
//                           children: [
//                             SlidableAction(
//                               backgroundColor: Colors.black45,
//                               onPressed: (_){
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => UpdateOkunacakBookView(
//                                       book: okunacakList[index],
//                                     ),
//                                   )
//                                 );
//                               },
//                               icon: Icons.edit,
//                               label: 'Edit',
//                             ),
                            
//                             SlidableAction(
//                               backgroundColor: Colors.red,
//                               onPressed: (_)async{
//                                 await Provider.of<OkunacakBookViewModel>(context,listen: false).deleteBook(okunacakList[index]);
//                               },
//                               icon: Icons.delete,
//                               label: 'Delete',
//                             ),
//                           ],
//                         ),
                        
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
            
//             IconButton(
//               iconSize: 40,
//               color: Color(0xFF363f93),
//               onPressed: (){
//                 Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => AddOkunacakBookView()));
//               }, 
//               icon: Icon(Icons.add_circle)
//             )
//           ],
//         ),
          
        
//       );
      
//   }
// }