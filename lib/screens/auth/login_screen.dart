import 'dart:developer';
import 'dart:io';

import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../../api/apis.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate=false;

  @override
  void initState() {
    //  implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate=true;
      });
    });
  }
  //handles google login button click
  _handleGoogleBtnClick(){
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);
      if(user !=null){
        log('\nUser:${user.user}');
      log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

      if((await APIs.userExists())){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
      else{
        await APIs.createUser().then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
        });
      }
      
      }
      
    });



  }
  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }catch(e){
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong ! Please Check Internet' );
      return null;

    }
}
//signout fuction
//_signOut() async{
//  await FirebaseAuth.instance.signOut();
//  await GoogleSignIn().signOut();
//}

  @override
  Widget build(BuildContext context) {
    //Initialize MediaQuery
    //mq=MediaQuery.of(context).size;
    return Scaffold(
      //AppBAr
      appBar: AppBar(
        //Home Button
        automaticallyImplyLeading: false,
         title: const Text('Welcome to Chat App'),
         
    ),
    body: Stack(children: [
      //applogo
      AnimatedPositioned(
        top: mq.height*.15,
        width: mq.width *.5,
        right:_isAnimate? mq.width *.25 : -mq.width*.5,
        duration:const Duration(seconds: 1 ) ,
        child: Image.asset('images/chat.png',)),
        //google logo
        Positioned(
        top: mq.height*.6,
        width: mq.width *.9,
        left:mq.width *.05,
        height: mq.height *.07,
        child: ElevatedButton.icon(
          style:ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(26, 135, 225, 79),shape:StadiumBorder() ) ,
          onPressed: (){
            _handleGoogleBtnClick();
            
          }, icon: Image.asset('images/search.png',height: mq.height*.04), 
          label: RichText(text:TextSpan(
            style: TextStyle(color: Colors.black,fontSize: 19),
            children:[
            TextSpan(text:'Login with '),
            TextSpan(text:'Google',style:TextStyle(fontWeight: FontWeight.bold) )
          ]) ,)))
    ]),
    
    );
  }
}