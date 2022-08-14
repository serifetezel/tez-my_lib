// ignore_for_file: unused_field, use_key_in_widget_constructors, avoid_print

import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/models/own_book_model.dart';
import '../components/text_widget.dart';
import '../models/update_own_book_view_model.dart';
import '../services/calculator.dart';
import 'main_book_page.dart';

class UpdateOkunacakBookView extends StatefulWidget {
  final OkunacakBook book;
  const UpdateOkunacakBookView({ required this.book });

  @override
  State<UpdateOkunacakBookView> createState() => _UpdateOkunacakBookViewState();
}

class _UpdateOkunacakBookViewState extends State<UpdateOkunacakBookView> {
  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController plannedController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  // ignore: prefer_typing_uninitialized_variables
  var _selectedDate;
  String ?_photoUrl;
  File ?_image;

  final picker = ImagePicker();

  // ignore: body_might_complete_normally_nullable
  Future<String?> uploadFile() async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .putFile(file);

      return await uploadFile.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose(){
    bookController.dispose();
    authorController.dispose();
    pageController.dispose();
    plannedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bookController.text = widget.book.bookName;
    authorController.text = widget.book.authorName;
    pageController.text = widget.book.pageNumber.toString();
    plannedController.text = Calculator.dateTimeToString(
      Calculator.datetimeFromTimestamp(widget.book.plannedDate)
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<UpdateOkunacakBookViewModel>(
      create: (_) => UpdateOkunacakBookViewModel(),
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
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/walpaper.jpg').image,
            )
          ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 0, right: 10),
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
                    height: height/8.5,
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
                      children: [
                        Expanded(child: AutoSizeText('" ${widget.book.bookName} "', 
                        maxLines: 2,
                        minFontSize: 7,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 25,
                        style: const TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),)),
                        const SizedBox(height: 5,),
                         const Text(' Kitabını Güncelle', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                      ]),
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
                       SizedBox(height: height/21),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Column(
                        children:[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: (_image == null)
                                  ?
                                   // ignore: avoid_unnecessary_containers
                                   Container(
                                     child: Stack(
                                       children: [ 
                                         InkWell(
                                         onTap: uploadFile,
                                         child: Container(
                                            height: height/4.4,
                                            width: width/2.8,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0, 3))
                                                ],
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                       widget.book.photoUrl),
                                                    fit: BoxFit.fill)),
                                          ),
                                       ),
                                       Positioned(
                                            bottom: -5,
                                            right: -10,
                                            child: IconButton(
                                              onPressed:()=> Text('deneme'),
                                              icon: const Icon(
                                                Icons.photo_camera_rounded,
                                                color: Colors.black87,
                                                size: 26,
                                              ),
                                            ),
                                          )
                                      ],
                                     ),
                                   )
                                  // ignore: avoid_unnecessary_containers
                                  : Container(
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: uploadFile,
                                            child: Container(
                                              height: height/4.3,
                                            width: width/2.8,
                                              child: Image.file(_image!),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.grey.shade200),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -5,
                                            right: -10,
                                            child: IconButton(
                                              onPressed:()=> Text('yazdır'),
                                              icon: const Icon(
                                                Icons.photo_camera_rounded,
                                                color: Colors.black87,
                                                size: 26,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ]),
                          const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child:
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   SizedBox(height: height/80),
                                   SizedBox(
                                    height: height/15.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.book,
                                            color: Color(0xFF7b8ea3)),
                                            SizedBox(width: width/23,),
                                        Expanded(
                                          child:TextFormField(
                                    controller: bookController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      hintText:
                                          // ignore: unnecessary_this
                                          this.widget.book.bookName,
                                      hintStyle: const TextStyle(fontSize: 30),
                                      
                                    ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Kitap Adı Boş Bırakılamaz.';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                        ),
                                      ],
                                    ),
                                   ),
                                   SizedBox(height: height/80),
                                  SizedBox(
                                    height: height/15.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.person,
                                            color: Color(0xFF7b8ea3)),
                                            const SizedBox(width: 18,),
                                        Expanded(
                                          child:TextFormField(
                                    //text: this.widget.articleInfo!.author,fontSize: 20,color: Color(0xFF7b8ea3)
                                    controller: authorController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      // ignore: unnecessary_this
                                      hintText: this.widget.book.authorName,
                                      hintStyle: const TextStyle(fontSize: 28),
                                      ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Yazar Adı Boş Bırakılamaz';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                 SizedBox(height: height/80),
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                    height: height/15.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.menu_book_sharp,
                                            color: Color(0xFF7b8ea3)),
                                            const SizedBox(width: 18,),
                                        Expanded(
                                          child: TextFormField(
                                          //text: this.widget.articleInfo!.page_number.toString(), fontSize: 16, color: Color(0xFF7b8ea3)
                                          controller: pageController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // ignore: unnecessary_this
                                            hintText: this
                                                .widget
                                                .book
                                                .pageNumber
                                                .toString(),
                                            hintStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF7b8ea3),
                                            ),
                                          ),
                                          validator: (value){
                                          if(value == null || value.isEmpty){
                                            return 'Kitap Sayfa Sayısı Boş Bırakılamaz.';
                                          }else {
                                            return null;
                                          }
                                        },
                                        ),
                                        
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(height: height/80),
                                  TextFormField(
                                    onTap: () async {
                                      _selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 1095))
                                      );
                                      plannedController.text = Calculator.dateTimeToString(_selectedDate!);
                                    },
                                    controller: plannedController,
                                    decoration: const InputDecoration(
                                      hintText: 'Planlanan Okuma Tarihi',
                                      icon: Icon(Icons.date_range, color: Color(0xFF7b8ea3),)
                                    ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Lütfen Tarih Belirleyiniz';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                   SizedBox(height: height/15.5,),
                      const Divider(color: Color(0xFF7b8ea3)),
                      GestureDetector(
                        onTap: ()async {
                         await context.read<UpdateOkunacakBookViewModel>().updateOkunacakBook(
                              bookName: bookController.text, 
                              authorName: authorController.text, 
                              photoUrl:  _photoUrl ?? widget.book.photoUrl, 
                              plannedDate: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.book.plannedDate),
                              pageNumber: int.parse(pageController.text), 
                              kullaniciid: auth.currentUser!.uid,
                              book: widget.book
                            );
                            Navigator.pop(context);
                        },
                        child: Container(
                          padding:  EdgeInsets.only(right: width/900),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:10.0),
                                child: TextWidget(text: "Güncelle", fontSize: 20),
                              ),
                              Expanded(child: Container()),
                              IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: ()async{
                                    await context.read<UpdateOkunacakBookViewModel>().updateOkunacakBook(
                                      bookName: bookController.text, 
                                      authorName: authorController.text, 
                                      photoUrl:  _photoUrl ?? widget.book.photoUrl, 
                                      plannedDate: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.book.plannedDate),
                                      pageNumber: int.parse(pageController.text), 
                                      kullaniciid: auth.currentUser!.uid,
                                      book: widget.book
                                    );
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF7b8ea3)),
                                ],
                              ),
                            ),
                            ),
                          ],
                        
                      ),
                      ) 
                       
                    ]
        ),
      ),
              ),
      )))
    ))));
  }
}

class UpdateOkunmusBookView extends StatefulWidget {
  final OkunmusBook book;
  const UpdateOkunmusBookView({required this.book});

  @override
  State<UpdateOkunmusBookView> createState() => _UpdateOkunmusBookViewState();
}

class _UpdateOkunmusBookViewState extends State<UpdateOkunmusBookView> {

  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController readDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  var _selectedDate;
  String ?_photoUrl;
  File ?_image;

  final picker = ImagePicker();

  Future pickImages() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<String?> uploadFile() async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .putFile(file);

      return await uploadFile.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    bookController.text = widget.book.bookName;
    authorController.text = widget.book.authorName;
    pageController.text = widget.book.pageNumber.toString();
    readDateController.text = Calculator.dateTimeToString(
      Calculator.datetimeFromTimestamp(widget.book.readDate)
    );
  }

  @override
  void dispose(){
    bookController.dispose();
    authorController.dispose();
    pageController.dispose();
    readDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<UpdateOkunmusBookViewModel>(
      create: (_) => UpdateOkunmusBookViewModel(),
      builder: (context, _) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/walpaper.jpg').image,
            )
          ),
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/walpaper.jpg').image,
            )
          ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 0, right: 10),
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
                    height: height/8.5,
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
                      children: [
                        Expanded(child: AutoSizeText('" ${widget.book.bookName} "', 
                        maxLines: 2,
                        minFontSize: 7,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 25,
                        style: const TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),)),
                        const SizedBox(height: 5,),
                         const Text(' Kitabını Güncelle', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                      ]),
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
                       SizedBox(height: height/21),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Column(
                        children:[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: (_image == null)
                                  ?
                                   // ignore: avoid_unnecessary_containers
                                   Container(
                                     child: Stack(
                                       children: [ 
                                         InkWell(
                                         onTap: uploadFile,
                                         child: Container(
                                            height: height/4.4,
                                            width: width/2.8,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0, 3))
                                                ],
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                       widget.book.photoUrl),
                                                    fit: BoxFit.fill)),
                                          ),
                                       ),
                                       Positioned(
                                            bottom: -5,
                                            right: -10,
                                            child: IconButton(
                                              onPressed: uploadFile,
                                              icon: const Icon(
                                                Icons.photo_camera_rounded,
                                                color: Colors.black87,
                                                size: 26,
                                              ),
                                            ),
                                          )
                                      ],
                                     ),
                                   )
                                  // ignore: avoid_unnecessary_containers
                                  : Container(
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: uploadFile,
                                            child: Container(
                                              height: height/4.3,
                                              width: width/2.8,
                                              child: Image.file(_image!),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.grey.shade200),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -5,
                                            right: -10,
                                            child: IconButton(
                                              onPressed: uploadFile,
                                              icon: const Icon(
                                                Icons.photo_camera_rounded,
                                                color: Colors.black87,
                                                size: 26,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ]),
                          const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child:
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   SizedBox(height: height/80),
                                   SizedBox(
                                    height: height/15.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.book,
                                            color: Color(0xFF7b8ea3)),
                                             SizedBox(width: width/23,),
                                        Expanded(
                                          child:TextFormField(
                                    controller: bookController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      hintText:
                                          // ignore: unnecessary_this
                                          this.widget.book.bookName,
                                      hintStyle: const TextStyle(fontSize: 30),
                                      
                                    ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Kitap Adı Boş Bırakılamaz.';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                        ),
                                      ],
                                    ),
                                   ), 
                                  SizedBox(height: height/80),
                                  SizedBox(
                                    height: height/15.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.person,
                                            color: Color(0xFF7b8ea3)),
                                            const SizedBox(width: 18,),
                                        Expanded(
                                          child:TextFormField(
                                    //text: this.widget.articleInfo!.author,fontSize: 20,color: Color(0xFF7b8ea3)
                                    controller: authorController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      // ignore: unnecessary_this
                                      hintText: this.widget.book.authorName,
                                      hintStyle: const TextStyle(fontSize: 28),
                                      ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Yazar Adı Boş Bırakılamaz';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Divider(color: Colors.grey),
                                   SizedBox(height: height/80),
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                    height: height/15.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.menu_book_sharp,
                                            color: Color(0xFF7b8ea3)),
                                            const SizedBox(width: 18,),
                                        Expanded(
                                          child: TextFormField(
                                          //text: this.widget.articleInfo!.page_number.toString(), fontSize: 16, color: Color(0xFF7b8ea3)
                                          controller: pageController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // ignore: unnecessary_this
                                            hintText: this
                                                .widget
                                                .book
                                                .pageNumber
                                                .toString(),
                                            hintStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF7b8ea3),
                                            ),
                                          ),
                                          validator: (value){
                                          if(value == null || value.isEmpty){
                                            return 'Kitap Sayfa Sayısı Boş Bırakılamaz.';
                                          }else {
                                            return null;
                                          }
                                        },
                                        ),
                                        
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(height: height/80),
                                  TextFormField(
                                    onTap: () async {
                                      _selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(-1000),
                                        lastDate: DateTime.now()
                                      );
                                      readDateController.text = Calculator.dateTimeToString(_selectedDate!);
                                    },
                                    controller: readDateController,
                                    decoration: const InputDecoration(
                                      hintText: 'Okunan Tarih',
                                      icon: Icon(Icons.date_range, color: Color(0xFF7b8ea3),)
                                    ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Lütfen Tarih Belirleyiniz';
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ),
                      
                      SizedBox(height: height/15.5,),
                      const Divider(color: Color(0xFF7b8ea3)),
                      GestureDetector(
                        onTap: ()async {
                         await context.read<UpdateOkunmusBookViewModel>().updateOkunmusBook(
                              bookName: bookController.text, 
                              authorName: authorController.text, 
                              photoUrl:  _photoUrl ?? widget.book.photoUrl, 
                              readDate: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.book.readDate),
                              pageNumber: int.parse(pageController.text), 
                              kullaniciid: auth.currentUser!.uid,
                              book: widget.book
                            );
                            Navigator.pop(context);
                        },
                        child: Container(
                          padding:  EdgeInsets.only(right: width/900),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:10.0),
                                child: TextWidget(text: "Güncelle", fontSize: 20),
                              ),
                              Expanded(child: Container()),
                              IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: ()async{
                                    await context.read<UpdateOkunmusBookViewModel>().updateOkunmusBook(
                                      bookName: bookController.text, 
                                      authorName: authorController.text, 
                                      photoUrl:  _photoUrl ?? widget.book.photoUrl, 
                                      readDate: _selectedDate ?? Calculator.datetimeFromTimestamp(widget.book.readDate),
                                      pageNumber: int.parse(pageController.text), 
                                      kullaniciid: auth.currentUser!.uid,
                                      book: widget.book
                                    );
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF7b8ea3)),
                          ],
                        
                      ),
                      ) 
                       
                    ]
        ),
      ),
              ),
      )))
    ))));
  }
}