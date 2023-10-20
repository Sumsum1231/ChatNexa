import 'dart:developer';

import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:chatapp/screens/home_screen.dart';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../api/apis.dart';

//Splash Screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1500),(){
      
      
      //exit full screen

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor:Colors.white, statusBarColor: Colors.white54 ));
        if(APIs.auth.currentUser !=null){
          log('\nUser:${APIs.auth.currentUser}');
          
          //navigate to homescreen
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> const HomeScreen()) );

        }else{
          //navigate to login screen
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> const LoginScreen()) );

        }

       
      
    });
  }

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
     
     
    body: Stack(children: [
      //applogo
      Positioned(
        top: mq.height*.15,
        width: mq.width *.5,
        right: mq.width *.25,
        
        child: Image.asset('images/chat.png',)),
        //google logo
        Positioned(
        bottom:mq.height*.15,
        
        width: mq.width ,
        child:
         const Text('MADE BY SUMIT 👻 '
         ,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black,letterSpacing:.5 ),))
    ]),
    
    );
  }
}