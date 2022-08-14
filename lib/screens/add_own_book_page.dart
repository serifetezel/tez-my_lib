// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, body_might_complete_normally_nullable, prefer_const_constructors

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/screens/okunacak_book_pagee.dart';
import '../models/add_own_book_model.dart';
import '../models/own_book_model.dart';
import '../models/own_book_view_model.dart';
import '../services/calculator.dart';
import 'main_book_page.dart';

class AddOkunacakBookView extends StatefulWidget {
  final Function getNew;
  const AddOkunacakBookView({ Key? key, required this.getNew}) : super(key: key);

  @override
  State<AddOkunacakBookView> createState() => _AddOkunacakBookViewState();
}

class _AddOkunacakBookViewState extends State<AddOkunacakBookView> {

  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController plannedController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _selectedDate;
  String ?_photoUrl;
  File ?_image;
  final picker = ImagePicker();
  List<OkunacakBook>? okuncakBookList;
  bool _isLoading = true;

  Future pickImages() async {
    final pickedFile = 
      await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
    if(pickedFile != null){
      _photoUrl = await uploadFile(_image!);
    }
  }
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> uploadFile(File imageFile) async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg')
          .putFile(file);

      return await uploadFile.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }
  Future<void> getOkunacakBooksfromApi() async {
    await Provider.of<OkunacakBookViewModel>(context, listen: false).getOkunacakBookList()!
    .then((value){
       setState(() {
        okuncakBookList = value;
        _isLoading = false;
      });
      print('-----------------------------------');
    });
  }

  @override
  void dispose(){
    bookController.dispose();
    authorController.dispose();
    pageController.dispose();
    plannedController.dispose();
    super.dispose();
  }
  bool readController = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddOkunacakBookViewModel>(
      create: (_) => AddOkunacakBookViewModel(),
      builder: (context, _) => Scaffold(
        
        backgroundColor: Colors.grey.shade100,
        
        body: Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Container(
            
            padding: EdgeInsets.all(15),
            child:SingleChildScrollView(child: Column(
              
              children: [
                Padding(
              padding: const EdgeInsets.only(top:50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ 
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                  height: 85,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.3,
                      color: Color(0xFF363f93)
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                    ),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child:  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text('Okunacaklar Listesine', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                       Text('Yeni Kitap Ekle', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                    ]),
                )),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.home_outlined, color: Color(0xFF363f93), size: 30,),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainBookPage())),
              )
                    ],
                  ),
                ),
                SizedBox(height: 70),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: bookController,
                              decoration: InputDecoration(
                                hintText: 'Kitap Adı: ',
                                icon: Icon(Icons.book, color: Color(0xFF363f93),),
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Lütfen ekleyeceğiniz kitabın adını doldurunuz';
                                }else{
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: authorController,
                              decoration: InputDecoration(
                                hintText: 'Kitap Yazar Adı: ',
                                icon: Icon(Icons.person, color: Color(0xFF363f93),),
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Lütfen ekleyeceğiniz kitabın yazar adını doldurunuz';
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: pageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Kitap Sayfa Sayısı: ',
                                icon: Icon(Icons.file_copy,color: Color(0xFF363f93)),
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                   return 'Lütfen ekleyeceğiniz kitabın sayfa sayısını doldurunuz';
                                }else{
                                  return null;
                                }
                              }
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              onTap: () async {
                                _selectedDate = await showDatePicker(
                                  context: context, 
                                  initialDate: DateTime.now(), 
                                  firstDate: DateTime.now(), 
                                  lastDate: DateTime.now().add(Duration(days: 1095))
                                );
                                plannedController.text = Calculator.dateTimeToString(_selectedDate!);
                              },
                              controller: plannedController,
                              decoration: InputDecoration(
                                hintText: 'Planlanan Okuma Tarihi: ',
                                icon: Icon(Icons.date_range, color: Color(0xFF363f93))
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Lütfen planladığınız okuma tarihini doldurunuz';
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 50,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    // ignore: sized_box_for_whitespace
                                    Container(
                                      height: 120,
                                      width: 100,
                                      child: (_image == null)
                                      ? Image(image: AssetImage('assets/open-books.png'))
                                      : Image.file(_image!),
                                      
                                    ),
                                    Positioned(
                                      bottom: -5,
                                      right: -10,
                                      child: IconButton(
                                        onPressed: pickImages,
                                        icon: Icon(Icons.photo_camera_rounded,
                                        color: Color(0xFF363f93),
                                        size: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            
                            SizedBox(height: 50,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF363f93),
                                fixedSize: Size(60, 50)
                              ),
                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  await context.read<AddOkunacakBookViewModel>().addOkunacakNewBook(
                                    bookName: bookController.text, 
                                    authorName: authorController.text,
                                    photoUrl:  _photoUrl , 
                                    plannedDate: _selectedDate, 
                                    pageNumber: int.parse(pageController.text),
                                    kullaniciid: auth.currentUser!.uid,
                                  );
                                  getOkunacakBooksfromApi();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OkunacakBookPage()));
                                }
                              }, 
                              child: Text('KAYDET')
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}

class AddOkunmusBookView extends StatefulWidget {
  final Function getNew;
  const AddOkunmusBookView({ Key? key, required this.getNew }) : super(key: key);

  @override
  State<AddOkunmusBookView> createState() => _AddOkunmusBookViewState();
}

class _AddOkunmusBookViewState extends State<AddOkunmusBookView> {

  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController readDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _selectedDate;
  String ?_photoUrl;
  File ?_image;
  final picker = ImagePicker();

  Future pickImages() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
    if(pickedFile != null){
      _photoUrl = await uploadFile(_image!);
    }
  }

  Future<String?> uploadFile(File imageFile) async {
    File file = File(_image!.path);

    try {
      var uploadFile = await firebase_storage.FirebaseStorage.instance
          .ref('bookPhotos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg')
          .putFile(file);

      return await uploadFile.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
  }
  FirebaseAuth auth = FirebaseAuth.instance;
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
    return ChangeNotifierProvider<AddOkunmusBookViewModel>(
      create: (_) => AddOkunmusBookViewModel(),
      builder: (context, _) => Scaffold(
        
        backgroundColor: Colors.grey.shade100,
        
        body: Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Container(
            
            padding: EdgeInsets.all(15),
            child:SingleChildScrollView(child: Column(
              children: [
                Padding(
              padding: const EdgeInsets.only(top:50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ 
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                  height: 114,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.3,
                      color: Color(0xFF363f93)
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                    ),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child:  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                       Text('Okunmuş Kitaplar', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                       Text('Listesine', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                       Text('Yeni Kitap Ekle', style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
                    ]),
                )),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.home_outlined, color: Color(0xFF363f93), size: 30,),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainBookPage())),
              )
                    ],
                  ),
                ),
                SizedBox(height: 70),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: bookController,
                              decoration: InputDecoration(
                                hintText: 'Kitap Adı: ',
                                icon: Icon(Icons.book, color: Color(0xFF363f93),),
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Lütfen ekleyeceğiniz kitabın adını doldurunuz';
                                }else{
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: authorController,
                              decoration: InputDecoration(
                                hintText: 'Kitap Yazar Adı: ',
                                icon: Icon(Icons.person, color: Color(0xFF363f93),),
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Lütfen ekleyeceğiniz kitabın yazar adını doldurunuz';
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: pageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Kitap Sayfa Sayısı: ',
                                icon: Icon(Icons.file_copy,color: Color(0xFF363f93)),
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                   return 'Lütfen ekleyeceğiniz kitabın sayfa sayısını doldurunuz';
                                }else{
                                  return null;
                                }
                              }
                            ),
                            SizedBox(height: 5),
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
                              decoration: InputDecoration(
                                hintText: 'Okunan Tarihi: ',
                                icon: Icon(Icons.date_range, color: Color(0xFF363f93))
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Lütfen planladığınız okuma tarihini doldurunuz';
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 50,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    // ignore: sized_box_for_whitespace
                                    Container(
                                      height: 120,
                                      width: 100,
                                      child: (_image == null)
                                      ? Image(image: AssetImage('assets/open-books.png'))
                                      : Image.file(_image!),
                                      
                                    ),
                                    Positioned(
                                      bottom: -5,
                                      right: -10,
                                      child: IconButton(
                                        onPressed: pickImages,
                                        icon: Icon(Icons.photo_camera_rounded,
                                        color: Color(0xFF363f93),
                                        size: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            
                            SizedBox(height: 50,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF363f93),
                                fixedSize: Size(60, 50)
                              ),
                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  await context.read<AddOkunmusBookViewModel>().addOkunmusNewBook(
                                    bookName: bookController.text, 
                                    authorName: authorController.text,
                                    photoUrl:  _photoUrl , 
                                    readDate: _selectedDate, 
                                    kullaniciid: auth.currentUser!.uid,
                                    pageNumber: int.parse(pageController.text),
                                  );
                                  await widget.getNew();
                                  Navigator.pop(context);
                                }
                              }, 
                              child: Text('KAYDET')
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}