// // ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:provider/provider.dart';
// import 'package:tez_app/screens/add_own_book_page.dart';
// import 'package:tez_app/screens/menu_bar.dart';
// import 'package:tez_app/screens/update_own_book_page.dart';

// import '../models/own_book_model.dart';
// import '../models/own_book_view_model.dart';
// import 'main_book_page.dart';
// import 'own_book_detail_page.dart';
// import 'own_book_note_list_page.dart';

// class OkunmusKitaplar extends StatefulWidget {

//   @override
//   State<OkunmusKitaplar> createState() => _OkunmusKitaplarState();
// }

// class _OkunmusKitaplarState extends State<OkunmusKitaplar> {
//   List<OkunmusBook>? okunmusBookList;
//   bool _isLoading = true;
//   bool isFiltering=false;
//   late List<OkunmusBook> filteredList;

//   void getOkunmusBooksfromApi() async {
//     Provider.of<OkunmusBookViewModel>(context, listen: false).getOkunmusBookList()!
//     .then((value) {
//       setState(() {
//         okunmusBookList = value;
//         debugPrint(okunmusBookList!.length.toString());
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   void initState(){
//     super.initState();
//     getOkunmusBooksfromApi();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;
//     var fullOkunmuslarList = okunmusBookList;
//     return Scaffold(
//         drawer: MyDrawer(),
//         backgroundColor: Colors.grey.shade100,
//         body: _isLoading ? Center(
//           child: CircularProgressIndicator(),
//         ) :
//         Column(
//           children: [
//             Container(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: Padding(
//               padding: const EdgeInsets.only(top:75.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     padding: EdgeInsets.zero,
//                     constraints: BoxConstraints(),
//                     icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   Container(
//                   height: height*0.12,
//                   width: width*0.7,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 1.3,
//                       color: Color(0xFF363f93)
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(20),
//                       topLeft: Radius.circular(20)
//                     ),
//                     color: Colors.grey.shade200,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                     children: [
//                       Text('Okunmuş Kitaplar', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
//                        Text(' Kütüphanesi', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
//                     ]),
//                 )),
                  
//                   IconButton(
//                     padding: EdgeInsets.zero,
//                     iconSize: 30,
//                     constraints: BoxConstraints(),
//                     icon: Icon(Icons.home_outlined, color: Color(0xFF363f93)),
//                     onPressed: () => Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => MainBookPage())),
//                   )
//                 ],
//               ),
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
//                           filteredList = fullOkunmuslarList!.where((book) => book.bookName.toLowerCase().contains(query.toLowerCase())).toList();
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
//                     : fullOkunmuslarList!.length,
//                     itemBuilder: (context, index){
//                       var okunmusList = isFiltering ? filteredList : fullOkunmuslarList;
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
//                               color: Color(0xFFD9D7F1),
                              
//                               child: GestureDetector(
//                                 onDoubleTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => OkunmusBookDetail(
//                                            book: okunmusList![index],
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
//                                     child: Image(image: NetworkImage(okunmusList![index].photoUrl),fit: BoxFit.cover,)),
//                                   title: Text(okunmusList[index].bookName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                  
//                                   subtitle: Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(Icons.person),
//                                             SizedBox(width: 10,),
//                                             Text(okunmusList[index].authorName, style: TextStyle(fontSize: 15),),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.menu_book_sharp),
//                                             SizedBox(width: 10,),
//                                             Text(okunmusList[index].pageNumber.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
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
//                                     builder: (context) => UpdateOkunmusBookView(
//                                       book: okunmusList[index],
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
//                                 await Provider.of<OkunmusBookViewModel>(context,listen: false).deleteBook(okunmusList[index]);
//                               },
//                               icon: Icons.delete,
//                               label: 'Delete',
//                             ),
//                           ],
//                         ),
//                         startActionPane: ActionPane(
//                           motion: const ScrollMotion(),
//                           dismissible: DismissiblePane(
//                             onDismissed: (){},
//                           ),
//                           children: [
//                             SlidableAction(
//                               backgroundColor: Colors.grey,
//                               onPressed: (_){
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                       NoteList(book: okunmusList[index])
//                                   )
//                                 );
//                               },
//                               icon: Icons.note_alt,
//                               label: 'Notes',
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
            
//             IconButton(
//               iconSize: 35,
//               color: Color(0xFF363f93),
//               onPressed: (){
//                 Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => AddOkunmusBookView()));
//               }, 
//               icon: Icon(Icons.add_circle)
//             ),
//             Divider(),
//           ],
//         ),
//     );
//   }
// }
