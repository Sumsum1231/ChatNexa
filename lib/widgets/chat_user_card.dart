import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/helper/my_date_util.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {



  //object  of message for last message info(if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:EdgeInsets.symmetric(horizontal: mq.width*0.04,vertical: 4),
      color:Colors.deepOrange[50],
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap:(){
          //for navigating to chatscreen
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user)));
        },
        child:  StreamBuilder(
          stream:APIs.getLastMessages(widget.user),
          builder: (context,snapshot){


            
            final data=snapshot.data?.docs;
                   
            final list=data?.map((e) => Message.fromJson(e.data()))
            .toList() ?? [];
            if(list.isNotEmpty)
              _message =list[0];

                   
                  



            return ListTile(


            //user profile picture
            
            leading:ClipRRect(
              borderRadius: BorderRadius.circular(mq.height*.3),
              child: CachedNetworkImage(
                width:mq.height * .055,
                height:mq.height * .055,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
                ),
            ),
              //Name of the person
              title:Text(widget.user.name) ,



              //Last message 
              subtitle: Text(
                _message!=null ?
                _message!.type==Type.image?
                'image':
                 _message!.msg
                : widget.user.about,
                 maxLines: 1,),
              
              
              //last message time
              trailing:_message ==null 
              ? null//show notinh when no message is sent
              : 
              _message!.read.isEmpty && _message!.fromid!=APIs.user.uid? 
              //show for unread message
              Container(width: 15,height: 15,
              decoration: 
              BoxDecoration(color: Colors.greenAccent.shade400
              ,borderRadius:BorderRadius.circular(10) )
              ) :
              //message sent time
               Text(
                MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
                style: const TextStyle(
                  color: Colors.black54)),
              
            );

        },)
      ),
    );
  }
}