
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, curly_braces_in_flow_control_structures, unused_element, avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tez_app/screens/main_book_page.dart';
import 'package:tez_app/screens/password_reset_page.dart';
import 'package:tez_app/screens/register_page.dart';
import 'package:tez_app/services/auth.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({ Key? key }) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> 
with TickerProviderStateMixin {
  late AnimationController _bookController;
  bool copAnimated = false;
  bool animateCafeText = false;

  @override
  void initState(){
    super.initState();
    _bookController = AnimationController(vsync: this);
    _bookController.addListener(() { 
      if(_bookController.value > 0.7){
        _bookController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,//Color(0xFFFFEDDB),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: copAnimated ? screenHeight / 2.1 : screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(copAnimated ? 40.0 : 0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: !copAnimated,
                  child: Lottie.asset(
                    'assets/booksplash2.json',
                    controller: _bookController,
                    onLoaded: (composition){
                      _bookController
                        ..duration = composition.duration
                        ..forward();
                    }
                  ),
                ),
                if ( !isKeyboard ) 
                Visibility(
                  visible: copAnimated,
                  child: Image.asset(
                    'assets/book2.png',
                    height: screenHeight/5.5,
                    width: screenWidth/5,
                  ),
                ),
                SizedBox(height:screenHeight/350),
                Center(
                  child: AnimatedOpacity(
                    opacity: animateCafeText ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: const Text(
                      'B O O K',
                      style: TextStyle(fontSize: 50.0, color: Color(0xFF363f93))//Color(0xFFFFEDDB)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: copAnimated, child: const _BottomPart(),
          )
        ],
      ),
    );
  }
}

class _BottomPart extends StatefulWidget {
  const _BottomPart({ Key? key }) : super(key: key);

  @override
  State<_BottomPart> createState() => _BottomPartState();
}

class _BottomPartState extends State<_BottomPart> {
  
  final _totalDots = 3;
  bool _obscureText = true;
  double _currentPosition = 0.0;
  double _validPosition(double position){
    if(position >= _totalDots)
      return 0;
    if(position < 0 )
      return _totalDots - 1.0;
    return position;
  }
   String getCurrentPositionPretty() {
    return (_currentPosition + 1.0).toStringAsPrecision(2);
  }
  _onPageChanged(int index){
    setState(() {
      _currentPosition = _currentPosition.ceilToDouble();
      _updatePosition(index.toDouble());
      print(index);
      print(_currentPosition);
    });
  }

  void _updatePosition(double position){
    setState(() => _currentPosition = _validPosition(position));
  }
  Widget _buildRow(List<Widget> widgets){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }
  final _signInFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: screenWidth/13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: _signInFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    validator: (value){
                      if(!EmailValidator.validate(value!)){
                        return 'Lütfen Email Adresinizi Kontrol Ediniz.';
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
                  SizedBox(height: 10.0),
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
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText == true ? Icons.visibility_off : Icons.visibility),
                      ),
                      hintText: 'Şifre',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
                    ),
                  ),
                  SizedBox(height: screenHeight/45),
                ],
              ),
            ),
          ),
          SizedBox(height: 5,),
          ElevatedButton(
            onPressed: ()async{
              if(_signInFormKey.currentState!.validate()){
                final response = await Provider.of<Auth>(context, listen: false)
                  .signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                if(response['status']){
                  final user = response['user'];
                   debugPrint(user.emailVerified.toString());
                  if(user.emailVerified){
                    print('Başarılı');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainBookPage()));
                  }else{
                    //mail onayla
                  }
                }else{
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Hatalı Giriş Yaptınız'),
                    action: SnackBarAction(
                      textColor: Colors.grey.shade50,
                      label: 'Close',
                      onPressed: (){},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } 
              }
            }, 
            child: Text('Giriş Yap'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF363f93),//Color(0xFFC1A3A3),
              fixedSize:  Size(screenWidth/1.4, screenHeight/15),
              side: BorderSide(color: Colors.black38, width: 2, style: BorderStyle.solid,),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
            }, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Henüz kayıtlı değil misiniz? ', style: TextStyle(color: Colors.black54)),
                Text(' Tıklayınız!', style: TextStyle(color: Color(0xFF363f93), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: ()async{
                  final user = await Provider.of<Auth>(context, listen: false).signInWithGoogle();
                  print(user);
                }, 
                child: Container(
                  width: screenWidth/10,
                  height: screenHeight/18,
                  decoration: BoxDecoration (
                    image: DecorationImage(
                    image: AssetImage('assets/google-logo.png'),
                    fit: BoxFit.cover,  
                  ),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PasswordResetPage()));
                },
                child: Column(
                  children: [
                    Text('Şifremi ',style: TextStyle(color: Color(0xFF363f93), fontWeight: FontWeight.bold)),
                    Text('Unuttum !',style: TextStyle(color: Color(0xFF363f93), fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
