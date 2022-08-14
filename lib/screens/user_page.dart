// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_app/screens/welcome_sign_in_page.dart';
import '../components/text_widget.dart';
import '../services/auth.dart';
import 'main_book_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        FutureBuilder(
          future: Provider.of<Auth>(context, listen: false).getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return displayUserInformation(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          },
        )
    );
  }

  Widget displayUserInformation(context, snapshot){
    final user = snapshot.data;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    debugPrint(user.toString(),);
    debugPrint(user.metadata.creationTime.toString(),);
    return Scaffold( 
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset('assets/walpaper.jpg').image,
            opacity: 0.4
          )
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: height/14),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size:30, ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainBookPage()));
                    },
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height*0.2),
                  Container(
                    padding: EdgeInsets.only(left: width/15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(text: "Kullanıcı Sayfası", fontSize: 30, color: Color(0xFF151D3B)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.asset('assets/walpaper2.jpg').image,
                                opacity: 0.4
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: height*0.31,
                    child: Stack(
                          children: [
                            Positioned(
                              top: height/25,
                              // ignore: unnecessary_new
                              child: new Material(
                                elevation: 0.0,
                                // ignore: unnecessary_new
                                child: new Container(
                                  height: height/2,
                                  width: width*0.90,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(0.1),
                                    boxShadow: [
                                      // ignore: unnecessary_new
                                      new BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        offset: Offset(-10.0, 0.0),
                                        blurRadius: 20.0,
                                        spreadRadius: 4.0
                                      )
                                    ]
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: height/8,
                              right: 0,
                              bottom: height/8,
                              child: SizedBox(
                                child: Icon(Icons.person_pin_rounded, size: 70,color: Color(0xFF151D3B),),
                                width: width/4.5,
                              ),
                            ),
                            Positioned(
                              top: height/17,
                              left: width*0.08,
                              child: SizedBox(
                                height: height/5,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        TextWidget(
                                          text: 'E- Mail: ',color: Color(0xFF151D3B),
                                          fontSize: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:8.0,left: 50.0),
                                              child: TextWidget(
                                                text: user.email.toString(),
                                                fontSize: 17,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        TextWidget(
                                          text: 'Kayıt Tarihi: ', color: Color(0xFF151D3B),
                                          fontSize: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:8.0,left: 50.0),
                                              child: TextWidget(
                                                text:  DateFormat('dd/MM/yyyy   H:mm').format(user.metadata.creationTime),
                                                fontSize: 17,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            )
                          ],
                       
                    )
                      
                    ),
                    Padding(
                      padding: EdgeInsets.only(right:width/10,top: height/60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: ()async{
                              SharedPreferences localStorage = await SharedPreferences.getInstance();
                                localStorage.remove('user');
                                Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => WelcomePage())
                                ); }, 
                            child: Text('Çıkış Yap',),
                            style: ElevatedButton.styleFrom(primary: Color(0xFF151D3B),onPrimary: Colors.white),
                          ),
                        ],
                      ),
                    )
              ],
            ),
        ],
      ),
    ));
  }

  Widget showSignOut(context, bool isAnonymous){
    if(isAnonymous == true){
      return ElevatedButton(
        child: Text("Sign In To Save You Data"),
        onPressed: (){},
      );
    }else{
      return ElevatedButton(
        child: Text("Sign Out"),
        onPressed: ()async{
          try{
            await Provider.of(context).auth.signOut();
          }catch(e){
            print(e);
          }
        },
      );
    }
  }
}

