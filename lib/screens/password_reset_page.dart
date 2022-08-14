// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/services/auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({ Key? key }) : super(key: key);

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding:  EdgeInsets.only(left:width/25, right: width/25, top:height/8),
        child: Form(
      key: _resetFormKey,
      child: Padding(
        padding: EdgeInsets.only(right:width/25,left:width/25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF363f93)),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: height/6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('ŞİFRE YENİLEME', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        SizedBox(width: width/8,),
                        Image(image: AssetImage('assets/şifre_yenileme3.png'),width: width/5, height: height/5,)
                      ],
                  ),
                  SizedBox(height: height/90),
                  TextFormField(
                    controller: _emailController,
                    validator: (value){
                      if(!EmailValidator.validate(value!)){
                        return 'Lütfen Geçerli Bir Mail Adresi Giriniz';
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'E-mail',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(height: height/30,),
                  ElevatedButton(
                    onPressed: ()async{
                      if(_resetFormKey.currentState!.validate()){
                        await Provider.of<Auth>(context, listen: false).sendPasswordResetEmail(_emailController.text);
                        await _showResetPasswordDialog();
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Gönder'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF363f93),
                      fixedSize: const Size(90, 50),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }
  Future<void> showMyDialog()async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget> [
                  Text('Merhaba, lütfen mailinizi kontrol ediniz'),
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

  Future<void> _showResetPasswordDialog()async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, lütfen mailinizi kontrol ediniz.'),
                Text('Linki tıklayarak şifrenizi yenileyebilirsiniz'),
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
}