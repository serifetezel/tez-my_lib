// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_null_comparison
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_app/services/database.dart';

class Auth{
  final _firebaseAuth = FirebaseAuth.instance;
  
  Future<String> getCurrentUID()async{
    return (await _firebaseAuth.currentUser!).uid;
  }
  
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser!;
  }

  Future<User?> createUserWithEmailAndPassword(String name, String email, String password) async {
    UserCredential userCredentials;

    try{
      userCredentials = await _firebaseAuth
        .createUserWithEmailAndPassword( email: email, password: password);
        User? user = userCredentials.user;

        await Database(uid: user?.uid).updateUserData(name, email, password);
      return userCredentials.user;
    } on FirebaseAuthException catch(e){
      print(e);
      rethrow;
    }
  }

  Future<Map<String,dynamic>> signInWithEmailAndPassword(String email, String password)async{
    try {
    final UserCredentials = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    Map<String,dynamic> data= {
      "status":true,
      "user":UserCredentials.user,
      "message":""
    };
    return data;
    } on FirebaseAuthException catch  (e) {
      Map<String,dynamic> data= {
      "status":false,
      "user":null,
      "message":e.message
    };
    return data;
    }
  }

  Future<User?> signInWithGoogle()async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser!=null){
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', userCredential.user!.email.toString());
      return userCredential.user;
    }
    else{
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email)async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Stream<User?> authStatus(){
    return _firebaseAuth.authStateChanges();
  }
 
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}

