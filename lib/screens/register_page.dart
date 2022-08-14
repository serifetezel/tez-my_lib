// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_element, avoid_print, unnecessary_new

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/screens/welcome_sign_in_page.dart';
import 'package:tez_app/services/auth.dart';

class SignUp extends StatefulWidget {

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Future<void> _showMyDialog()async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: 
                const <Widget> [
                  Text('Merhaba, lütfen mailinizi kontrol ediniz.'),
                  Text('Onay linkini tıklayıp tekrar giriş yapabilirsiniz.'),
                ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
      TextEditingController _nameController = TextEditingController();
      TextEditingController _emailController = TextEditingController();
      TextEditingController _passwordController = TextEditingController();
      TextEditingController _rePasswordController = TextEditingController();

      final _registerFormKey = GlobalKey<FormState>();
      bool _obscureText = true;
      bool _obscureText2 = true;

      @override
      void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
         Container(
           height: MediaQuery.of(context).size.height/2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)
              ),
            color: Color(0xFF363f93)
          ),
         ),
           Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: height/50),
                        Container(
                          height: height/12,
                          width: width/7,
                          decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/person5.png"),
                            fit: BoxFit.fill,
                          )
                        )
                        ),
                        SizedBox(height: height/45),
                        Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('KAYIT FORMU', style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: height/40),
                        Container(
                          decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)
              ),
                  color: Colors.white
                ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: height/30),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: 'İsim',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                  ),
                                ),
                                SizedBox(height: height/60),
                                TextFormField(
                                  controller: _emailController,
                                  validator: (value){
                                    if(!EmailValidator.validate(value!)){
                                      return 'Lütfen Geçerli Bir Mail Adresi Giriniz.';
                                    }else{
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    hintText: 'E-mail',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
                                  ),
                                ),
                                SizedBox(height: height/60),
                                TextFormField(
                                  controller: _passwordController,
                                  validator: (value){
                                    if(value!.length<6){
                                      return 'Şifreniz en az 6 karakterden oluşmalıdır.';
                                    }else{
                                      return null;
                                    }
                                  },
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    suffixIcon:  GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Icon(_obscureText == true ? Icons.visibility_off : Icons.visibility),
                                          ),
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Şifre',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
                                  ),
                                ),
                                SizedBox(height: height/60),
                                TextFormField(controller: _rePasswordController,
                                validator: (value){
                                  if(value!=_passwordController.text){
                                    return 'Şifreler Uyuşmuyor';
                                  }else{
                                    return null;
                                  }
                                },
                                obscureText: _obscureText2,
                                decoration: InputDecoration(
                                  suffixIcon:  GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                            child: Icon(_obscureText2 == true ? Icons.visibility_off : Icons.visibility),
                                          ),
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: 'Şifre Tekrar',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                                ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:30),
                            ElevatedButton(
                              onPressed: () async {
                                try{
                                  if(_registerFormKey.currentState!.validate()){
                                    final user = await Provider.of<Auth>(context,listen: false)
                                    .createUserWithEmailAndPassword(
                                      _nameController.text, 
                                      _emailController.text,
                                      _passwordController.text
                                    );
                                    if(!user!.emailVerified){
                                      await user.sendEmailVerification();
                                    }
                                    await _showMyDialog();
                                    await Provider.of<Auth>(context, listen: false).signOut();
                                    setState(() {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context)=> WelcomePage()));
                                    });
                                  }
                                }
                                on FirebaseAuthException catch(e){
                                  print('Kayıt formu içerisinde hata yakalandı, ${e.message}');
                                }
                              },
                              child: Icon(Icons.check, size: 30),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF363f93),
                                fixedSize: const Size(80,50),
                                side: BorderSide(color: Colors.black38, width: 2, style: BorderStyle.solid)
                              ), 
                            ),
                            TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Zaten Üye misiniz? ', style: TextStyle(color: Colors.black54),),
                                  Text('Tıklayınız!', style: TextStyle(color: Color(0xFF363f93)),),
                                ],
                              ),
                            )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
        ],
      ),
    );
  }
}