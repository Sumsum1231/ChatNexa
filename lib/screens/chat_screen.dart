import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //for stroing all messages
  List<Message> list=[];

  final _textController=TextEditingController();

  //for storing value of showing or hiding emoji
  bool _showEmoji=false,_isUploading = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if search button is on and back is pressed then close search
        //or else simple close current screen on back button click
        onWillPop:(){
          if(_showEmoji){
            setState(() {
              
              _showEmoji=!_showEmoji;
              
            });
          return Future.value(false);
          

          }
          else{
            return Future.value(true);

          }
        } ,
          child: Scaffold(
            //appbar
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            
            backgroundColor:const Color.fromARGB(255, 218, 246, 243) ,
            //body
            body: Column(children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user) ,
                  builder: (context,snapshot){
                
                    switch (snapshot.connectionState) {
                      //if data is leading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      //if all data or some daat is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                      
                
                
                
                    
                       final data=snapshot.data?.docs;
                       
                       list=data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            
            
                    
                    
                    if(list.isNotEmpty){
                      return ListView.builder(
                        reverse: true,
                        itemCount:list.length,
                        padding: EdgeInsets.only(top:mq.height*0.02),
                        physics: BouncingScrollPhysics() ,
                        itemBuilder: (context,index){
                        
                        return MessageCard(message: list[index],);
                              });
                    }
                    else{
                      return const Center(child: Text('Say Hii! 👋',style: TextStyle(fontSize: 20)));
                    }
                      
                        
                    }
                
                
                
                
                    
                    
                  },
                    
                  ),
              ),
              
              
              
              _chatInput(),
            if(_showEmoji)          
            //show wemoji on keyboard emoji button click and vice versa            
            SizedBox(
              height: mq.height*.35,
              child:   EmojiPicker(
              
                  
              
                  textEditingController: _textController,
              
                  config: Config(
              
                      columns: 8,
                      bgColor: Color.fromARGB(255, 234, 248, 255),
                      
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), 
              
                      
              
                  ),
              
              ),
            )
              
              
              ],
            ),
          ),
        ),
      ),
    );
    
  }

  //app bar widget
  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: StreamBuilder(stream:APIs.getUserinfo(widget.user) ,builder:(context, snapshot) {
        return Row(
        children: [
          //back button
          IconButton(onPressed: ()=> Navigator.pop(context)
          ,  icon: const Icon(Icons.arrow_back,color: Colors.black87,)),
          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*.3),
            child: CachedNetworkImage(
              width:mq.height * .05,
              height:mq.height * .05,
            imageUrl: widget.user.image,
            //placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
               ),
          ),
    
          SizedBox(width: 10,),
    
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user name
            Text(widget.user.name, style: const TextStyle(fontSize:16,color: Color.fromARGB(255, 0, 0, 0)
            ,fontWeight: FontWeight.w500 )),
            //for adding some space
            SizedBox(height: 2,),
    
            //last seen of user
            const Text('Last seen time not available', style: const TextStyle(fontSize:13,color: Color.fromARGB(255, 0, 0, 0)
             ))
          ],)
        ],
      );
 
        
      }, )   );
    
  }
  
  //bottom chat input fields
  Widget _chatInput(){
    return Padding(
      
      padding:  EdgeInsets.symmetric(vertical: mq.height*.01,horizontal:mq.width*.025),
      child: Row(
        children: [
          //input fields and buttons
          Expanded(
            child: Card(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(onPressed: (){
                    FocusScope.of(context).unfocus();
                    setState(() =>
                      _showEmoji=!_showEmoji
                    );
                  },
                      icon: const Icon(Icons.emoji_emotions
                    ,color: Colors.blueAccent,size: 26)),
            
            
                    Expanded(child: TextField(
                      controller:_textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if(_showEmoji)
                        setState(() =>
                      _showEmoji=!_showEmoji
                    );
                      },
                      decoration: const InputDecoration(hintText: 'Type Something...', hintStyle: TextStyle(color: Colors.blueGrey)),
                    )
                    ),
                    //picking  multipleimage from galary 
                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();


                      // uploading and sending image one by one.
                final List<XFile> images = await picker.pickMultiImage( imageQuality: 70);
                for (var i in images) {
                  log('Image Path: ${i.path}');
                   await APIs.sendChatImage(
                    widget.user,
                    File(i.path));


                  
                }
                
                if(images.isNotEmpty)
                {
                  
                  
                 
                  

                  }
                  },
                      icon: const Icon(Icons.image
                    ,color: Colors.blueAccent,size: 26)),
                    //pick image from camera button
                  IconButton(onPressed: ()  async {
                    final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                    
                  },
                      icon: const Icon(Icons.camera
                    ,color: Colors.blueAccent,size: 26,)),

                    SizedBox(width: mq.width*.02,)
                    ],
                    
                    ),
            ),
          ),
    
    
          //send message button
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              APIs.sendMessage(widget.user, 
              _textController.text, Type.text);
              _textController.text='';
            }
          },
          minWidth: 0,
          padding: EdgeInsets.only(bottom: 10,top: 10,right: 5,left: 10),
          shape: CircleBorder(),
          color: Colors.green,
          child: Icon(Icons.send,color: Colors.white,size: 28,),)
        ],
      ),
    );
  }
 
}