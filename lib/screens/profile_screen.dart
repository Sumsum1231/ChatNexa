



import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {

  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formkey=GlobalKey<FormState>();
  String ? _image;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        //AppBAr
        appBar: AppBar(
          //Home Button
          
           title: const Text('Profile Screen'),
           
      ),
      //Button to Add New User
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            //for showing progress dialog
            Dialogs.showProgressBar(context);
    
            //signout from pop
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {});
              //for hiding progress dialog
                Navigator.pop(context);
                //for moving to homescreen
                Navigator.pop(context);
    
                //replacing homescreen with login screen
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
            });
            
          
          
        },icon:const Icon(Icons.logout) ,label: Text('LogOut')),
      ),
      
        //body:
        body:Form(
          key: formkey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: mq.width *0.05),
            child: SingleChildScrollView(
              child: Column(
               
                children: [
                //for adding some space
                SizedBox(width:mq.width,height: mq.height*.05,),
                //user profile picture
                
                Stack(
                  children: [
                    //profile picture

                    _image!=null ? 
                    //local image
                     ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height*.3),
                      child: Image.file(
                        File(_image!),
                        width:mq.height * .2,
                        height:mq.height * .2,
                        fit:BoxFit.cover
                     
                         ),
                    )
                    :
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height*.3),
                      child: CachedNetworkImage(
                        width:mq.height * .2,
                        height:mq.height * .2,
                        fit:BoxFit.cover,
                      imageUrl: widget.user.image,
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                         ),
                    ),
                    //edit image button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(onPressed: (){
                        _showBottomSheet();
                      },
                      color:Colors.white ,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.edit,color: Colors.blueAccent,),),
                    )
                  ],
                ),
                //for adding some space
                SizedBox(height: mq.height*.02,),
                Text(widget.user.email,style: TextStyle(color: Colors.black54,fontSize: 16),),
            
                //for adding some space
                SizedBox(height: mq.height*.05,),
            
            
                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (val)=> APIs.me.name=val ?? '',
                  validator:(val)=> val!=null && val.isNotEmpty ?null
                   :'Required Field',
                  decoration: InputDecoration(
                    prefixIcon:Icon(Icons.person) ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg Happy Singh',label: Text('Name'),
                    ),
                  
                ),
            
                //for adding some space
                SizedBox(height: mq.height*.02,),
                
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val)=> APIs.me.about=val ?? '',
                  validator:(val)=> val!=null && val.isNotEmpty ?null
                   :'Required Field',
                  decoration: InputDecoration(
                    prefixIcon:Icon(Icons.info_outline) ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg Happy ',label: Text('About'),
                    ),
            
                ),    
                    
                //for adding some space
                SizedBox(height: mq.height*.02,),  
                //update profile button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(),minimumSize: Size(mq.width*.5, mq.height*.06)),
                  onPressed: (){
                    if(formkey.currentState!.validate()){
                      formkey.currentState!.save();
                      APIs.updateUserInfo().then((value){
                        Dialogs.showSnackbar(context, 'Profile Updated Successfully');
                      });

                    }

                  }, icon:Icon(Icons.login_outlined),
                label:const Text('UPDATE',style: TextStyle(fontSize: 16),),)
              ],),
            ),
          ),
        )
        ),
    );

    
  }
   //bottom sheet to picking a profile picture
  void _showBottomSheet(){

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
       builder: (_){
      return 
      ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height*.03,bottom: mq.height*.05),
        children: [
          //pick profile picture label
          const Text('Pick Profile Picture',
          textAlign:TextAlign.center ,
          style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.w500),),

          SizedBox(height:mq.height*.02),
          //take picture from galary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ElevatedButton(
            style:ElevatedButton.styleFrom(
              backgroundColor: Colors.white,fixedSize: Size(mq.width*.3, mq.height*.15),
              shape: const CircleBorder(),
            ),
            onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if(image!=null)
                {
                  log('Image Path: ${image.path} -- MintType: ${image.mimeType}');
                  setState(() {
                    _image=image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                  //for hiding bottomsheet
                  Navigator.pop(context);
                }

            }, child: Image.asset(
            'images/add-image.png'
          )),
          //click picture through camera
          ElevatedButton(
            style:ElevatedButton.styleFrom(
              backgroundColor: Colors.white,fixedSize: Size(mq.width*.3, mq.height*.15),
              shape: const CircleBorder(),
            ),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if(image!=null)
                {
                  log('Image Path: ${image.path} ');
                  setState(() {
                    _image=image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                  //for hiding bottomsheet
                  Navigator.pop(context);
                }
            }, child: Image.asset(
            'images/camera.png'
          ))],
          )
        ],
        
      );
    });

  }
}