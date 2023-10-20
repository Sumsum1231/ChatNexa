import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_user.dart';
import '../models/message.dart';

class APIs{
  //for authentication 
  static FirebaseAuth auth=FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore=FirebaseFirestore.instance;



  //for accessing firebase storage 
  static FirebaseStorage storage=FirebaseStorage.instance;
  //returns current user if not null
  static User get user=> auth.currentUser!;

  //for storing self information
  static late ChatUser me;


  //for checking if user already exist or not?
  static Future<bool>userExists()async{
    return (await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .get()
    ).exists;
  }

   static Future<void>getSelfInfo()async{
    (await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .get()
    .then((user) async {
      if(user.exists)
      {
        me=ChatUser.fromJson(user.data()!);
        log('My Data:${user.data()}');
      }else{
        await createUser().then((value) => getSelfInfo()); 
      }

    })
    );
  }


  //for creating a new user
  static Future<void>createUser()async{
    final time=DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser=ChatUser(
      id: auth.currentUser!.uid,
       name: user.displayName.toString(),
       email: user.email.toString(),
       about: "Hey I am using My Chat!",
       image:user.photoURL.toString() ,
       createdAt:time ,
       isOnline: false,
       lastActive:time ,
       pushToken: '');
    return await firestore
    .collection('users').doc(user.uid).set(chatUser.toJson());
    
  }
  //for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){

    return firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }

  //to update user info
  static Future<void>updateUserInfo()async{
    await firestore
    .collection('users')
    .doc(user.uid).update({'name':me.name,
    'about':me.about})
    ;
  }

  //update profile picture of user
  static Future<void> updateProfilePicture(File file) async{
    //getting image file extention 
    final ext=file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    
    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
      log('Data Transffered: ${p0.bytesTransferred/1000}kb');
    } );
    //updating image in firestore databse
    me.image=await ref.getDownloadURL() ;
    await firestore
    .collection('users')
    .doc(user.uid).update({'image':me.image
    });
    


  }

  //for getting specific user info
  static Stream<QuerySnapshot<Map<String,dynamic>>>getUserinfo(
    ChatUser chatUser){
      return firestore.collection('users').where('id', isEqualTo: chatUser.id).snapshots();
    }

  //update online or last active status of the user
  static Future<void> updateActiveStatus(bool isOnline) async{
     firestore.collection('users').doc(user.uid).update({'is_online': isOnline, 'last_active':DateTime.now().millisecondsSinceEpoch.toString()});
  }


  
  
  
  /**
   *********************Chat Screen Related APIs**********************
   */

  //useful for getting conversation_id
  static String getConversationID(String id)=> user.uid.hashCode <=id.hashCode
    ?'${user.uid}_$id'
    :'${id}_${user.uid}';

  //for getting all messsages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user){

    return firestore
    .collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent',descending: true)
    .snapshots();
  }

  //chats (collectiobs) --> conversation_id (doc) --> messages(collection) --> message (doc)

  //for sending message
  static Future<void> sendMessage(ChatUser chatUser,String msg, Type type)async{

    //message sending time (also used as id)
    final time=DateTime.now().millisecondsSinceEpoch.toString();

    
     //message to send
    final Message message =Message(msg:msg ,
     read: '',
      told: chatUser.id,
       type: type,
        sent: time, fromid: user.uid);
    final ref=firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());

  }

  //update read status of message 
  static Future<void> updateMessageReadStatus(Message message)async{
    firestore.collection('chats/${getConversationID(message.fromid)}/messages/');

  }

  //get only last message of a specific chAt
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(ChatUser user){

    return firestore.collection('chats/${getConversationID(user.id)}/messages/')
    
    .orderBy('sent',descending: true)
    .limit(1)
    .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser,File file) async {
    //getting image file extention 
    final ext=file.path.split('.').last;
    

    //storage file ref with path
    final ref = storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    
    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0){
      log('Data Transffered: ${p0.bytesTransferred/1000}kb');
    } );
    //updating image in firestore databse
    final imageUrl=await ref.getDownloadURL() ;
    await APIs.sendMessage(chatUser,imageUrl, Type.image);

  }

}