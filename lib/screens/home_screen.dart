


import 'dart:convert';
import 'dart:developer';

import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

//for storing all users
  List<ChatUser> list=[];

  //for storing searched items
  final List<ChatUser> _searchList=[];

  //for storing search status
  bool _isSearching=false;

  @override
  void initState() { 
    super.initState();
    APIs.getSelfInfo();
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search button is on and back is pressed then close search
        //or else simple close current screen on back button click
        onWillPop:(){
          if(_isSearching){
            setState(() {
              
              _isSearching=!_isSearching;
              
            });
          return Future.value(false);
          

          }
          else{
            return Future.value(true);

          }
        } ,
        child: Scaffold(
          //AppBAr
          appBar: AppBar(
            //Home Button
            leading: Icon(CupertinoIcons.home),
             title: _isSearching ?
             
             TextField(
              decoration:const InputDecoration(
                border: InputBorder.none,
                hintText: ' Name, Email, ...',
                
                
              ) ,
              autofocus: true,
          
              style: const TextStyle(fontSize: 17,letterSpacing:0.5),
          
              //when search list changes then updated search list
              onChanged: (val){
                //search logic
                _searchList.clear();
                for(var i in list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
          
                }
              },
             ): Text('Chat App'),
             actions: [
              //Search Button
              IconButton(
                
                onPressed: (){
                  setState(() {
                    _isSearching=!_isSearching;
                  });
                }
                , icon:  Icon(
                  _isSearching ? CupertinoIcons.clear_circled_solid:
                   Icons.search)),
              //Features button
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user:APIs.me)));
              }, icon: const Icon(Icons.more_vert))
              
             ],
        ),
        //Button to Add New User
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom:10),
          child: FloatingActionButton(onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },child:const Icon(Icons.add_comment_rounded) ,),
        ),
        
          body: StreamBuilder(
            stream: APIs.getAllUsers() ,
            builder: (context,snapshot){
          
              switch (snapshot.connectionState) {
                //if data is leading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child:CircularProgressIndicator());
                //if all data or some daat is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                
          
          
          
              
                final data=snapshot.data?.docs;
              list=data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                
              
              if(list.isNotEmpty){
                return ListView.builder(
                  itemCount:_isSearching? _searchList.length:list.length,
                  padding: EdgeInsets.only(top:mq.height*0.02),
                  physics: BouncingScrollPhysics() ,
                  itemBuilder: (context,index){
                  return ChatUserCard(user:_isSearching? _searchList[index]:list[index],);
                  //return Text('Name: ${list[index]}');
                        });
              }
              else{
                return const Center(child: Text('No Connection Found',style: TextStyle(fontSize: 20)));
              }
                
                  
              }
          
          
          
          
              
              
            },
              
            ),
          ),
      ),
    );
    
  }

 
}