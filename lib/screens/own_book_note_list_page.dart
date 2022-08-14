// ignore_for_file: unnecessary_string_interpolations

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/notes_list_model.dart';
import '../models/notes_model.dart';
import '../models/own_book_model.dart';
import '../services/calculator.dart';
import 'main_book_page.dart';

class NoteList extends StatefulWidget {
  
  final OkunmusBook book;
  const NoteList({Key? key, required this.book}) : super(key: key);
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    List<Notes> notes = widget.book.notes;
    return  ChangeNotifierProvider<OkunmusNotesListModel>(
      create: (context)=>OkunmusNotesListModel(),
      
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.grey[50],
            elevation: 0.0,
          ),
        body: Padding(
          padding:  EdgeInsets.only(top:height/30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children:[ Container(
                    padding: const EdgeInsets.only(right: 20, left: 20),
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
                  height: 90,
                  width: 280,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: AutoSizeText('"${widget.book.bookName}" ',
                        maxLines: 2,
                        minFontSize: 7,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 25,
                       // ignore: prefer_const_constructors
                       style: TextStyle(color:Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),)),
                       const Text('Kitabına Ait Notların', style: TextStyle(color: Color(0xFF363f93),fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
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
                  )
                   ] ),
                   const SizedBox(height: 30,),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index){
                      return Slidable(child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.notes_sharp),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text('${notes[index].note}'),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.date_range_sharp),
                              const SizedBox(width: 10,),
                              Text('${notes[index].date.toDate()}'),
                              const SizedBox(width: 30,),
                              const Icon(Icons.file_copy),
                              Text('${notes[index].page.toString()}')
                            ],
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
                              backgroundColor: Colors.red,
                              onPressed: (_)async{
                                await Provider.of<OkunmusNotesListModel>(context,listen: false).deleteNote(notes[index]);
                              },
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                    );
                    }, 
                    separatorBuilder: (context, _) => Divider(thickness: 3,color: Colors.grey.shade200,), 
                    itemCount: notes.length
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Notes? newNote = 
                      await showModalBottomSheet<Notes>(
                        enableDrag: false,
                        isDismissible: false,
                        builder: (BuildContext context){
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: NoteForm(),
                          );
                        },
                        context: context,
                      );
                      if(newNote != null){
                        setState(() {
                          notes.add(newNote);
                        });
                        context.read<OkunmusNotesListModel>().updateNote(
                          book: widget.book, noteList: notes
                        );
                      }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.add_circle,size: 35, color: Color(0xFF363f93),),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class NoteForm extends StatefulWidget {

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  TextEditingController noteController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    noteController.dispose();
    pageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OkunmusNotesListModel(),
      builder: (context,_) => Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Stack(
                      children: const [
                        Image(
                          width: 80,
                          height: 80,
                          image: AssetImage('assets/notes.gif'),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: noteController,
                          textAlignVertical: TextAlignVertical.center,
                          maxLines:3,
                          decoration: const InputDecoration(
                            hintText: 'Not...',
                            
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Not Ekleyiniz';
                            } else{
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: pageController,
                      decoration: const InputDecoration(
                        hintText: 'Sayfa ?',
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Sayfa Belirleyiniz.';
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: TextFormField(
                      onTap: () async {
                        _selectedDate = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(-1000),
                          lastDate: DateTime.now().add(const Duration(days: 365))
                        ))!;
                        dateController.text = 
                          Calculator.dateTimeToString(_selectedDate);
                      },
                      controller: dateController,
                      decoration: const InputDecoration(
                        hintText: 'Not Tarihi',
                        prefixIcon: Icon(Icons.date_range)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Lütfen Tarih Belirleyiniz';
                        }else{
                          return null;
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF363f93)
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        Notes newNote = Notes(
                          note: noteController.text, 
                          page: pageController.text, 
                          date: Calculator.datetimeToTimestamp(_selectedDate),
                        );
                        Navigator.pop(context, newNote);
                      }
                    },
                    child: const Text('Yeni Not Ekle'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF363f93)
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: const Text('İPTAL'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}