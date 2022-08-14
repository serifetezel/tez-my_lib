import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/screens/own_book_note_list_page.dart';
import 'package:tez_app/screens/update_own_book_page.dart';
import '../models/own_book_model.dart';
import '../models/own_book_view_model.dart';
import '../services/calculator.dart';
import 'main_book_page.dart';

class OkunacakBookDetail extends StatefulWidget {
  final OkunacakBook book;
  // ignore: use_key_in_widget_constructors
  const OkunacakBookDetail({ required this.book });
  @override
  _OkunacakBookDetailState createState() => _OkunacakBookDetailState();
}

class _OkunacakBookDetailState extends State<OkunacakBookDetail> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<OkunacakBookViewModel>(
      create: (_) => OkunacakBookViewModel(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: const Color(0xFFffffff),
          elevation: 0.0,
        ),
          body: Container(
            decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset('assets/walpaper.jpg').image,
        )
      ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: 
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding:  EdgeInsets.only(left: 0, right: width/30),
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
                    height: height/8,
                    width: width/1.5,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('" ${widget.book.bookName} "', style: const TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                          const SizedBox(height: 5,),
                        ]),
                      ),
                  )),
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
                      const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width/2.5,
                            height: height/3.5,
                            child: Card( elevation: 15, child: Image(image: NetworkImage(widget.book.photoUrl), fit: BoxFit.fill,)
                          )),
                        ],
                      ),
                    ),
                     SizedBox(height: height/50,),
                    IntrinsicHeight(child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateOkunacakBookView(
                                            book: widget.book,
                                          ),
                                        )
                                      );
                                    }, icon: const Icon(Icons.edit), color: Colors.green,iconSize: 24,),
                            SizedBox(width: width/24),
                            IconButton(onPressed: ()async{
                              await Provider.of<OkunacakBookViewModel>(context,listen: false).deleteBook(widget.book);
                            }, icon: const Icon(Icons.delete), color: Colors.red,iconSize: 24,),

                      ],
                    )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Kitap Adı: ', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(widget.book.bookName,style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Yazar Adı: ', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(widget.book.authorName,style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Sayfa Sayısı: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(widget.book.pageNumber.toString(),style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Planlanan Okuma Tarihi: ', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(Calculator.dateTimeToString(widget.book.plannedDate.toDate()),style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 35,),
                    
                  ],
                ),
              )
            ),
          ),
      ),
    );
  }
}

class OkunmusBookDetail extends StatefulWidget {
  final OkunmusBook book;
  // ignore: use_key_in_widget_constructors
  const OkunmusBookDetail({ required this.book });
  @override
  _OkunmusBookDetailState createState() => _OkunmusBookDetailState();
}
class _OkunmusBookDetailState extends State<OkunmusBookDetail> {
  
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<OkunmusBookViewModel>(
      create: (_) => OkunmusBookViewModel(),
       builder: (context, _) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: const Color(0xFFffffff),
          elevation: 0.0,
        ),
          body: Container(
            decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset('assets/walpaper.jpg').image,
        )
      ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: 
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 0, right: width/30),
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
                    height: height/8,
                    width: width/1.5,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('" ${widget.book.bookName} "', style: const TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                          const SizedBox(height: 5,),
                          // const Text(' Kitabına Ait Detaylar', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                        ]),
                      ),
                  )),
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
                      const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width/2.5,
                            height: height/3.5,
                            child: Card( elevation: 15, child: Image(image: NetworkImage(widget.book.photoUrl), fit: BoxFit.fill,)
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    IntrinsicHeight(child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/notes.png', width: 21,height: 21,),
                          color: const Color(0xFF06113C),
                          onPressed: () {
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => NoteList(book: widget.book,))
                            );
                          },
                        ),
                        const SizedBox(width: 8,),
                        
                        IconButton(onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateOkunmusBookView(
                                            book: widget.book,
                                          ),
                                        )
                                      );
                                    }, icon: const Icon(Icons.edit), color: Colors.green,iconSize: 24,),//Icon(Icons.update), color: Color(0xFF363f93),iconSize: 30,),
                        const SizedBox(width:8,),
                        
                        //SizedBox(width: 10,),
                        IconButton(onPressed: ()async{
                          await Provider.of<OkunmusBookViewModel>(context,listen: false).deleteBook(widget.book);
                        }, icon: const Icon(Icons.delete), color: Colors.red,iconSize:24,),

                      ],
                    )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Kitap Adı: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(widget.book.bookName,style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           const Text('Yazar Adı: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Expanded(child: AutoSizeText(widget.book.authorName, textAlign: TextAlign.left,style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),))
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Sayfa Sayısı: ', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(widget.book.pageNumber.toString(),style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Planlanan Okuma Tarihi: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text(Calculator.dateTimeToString(widget.book.readDate.toDate()),style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 20 ),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(height: 3,thickness: 2,),
                    const SizedBox(height: 35,),
                    
                  ],
                ),
              )
            ),
          ),
      ),

    );
  }
}

