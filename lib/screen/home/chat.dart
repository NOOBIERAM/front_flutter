import 'package:flutt_mobile/service/friend_service.dart';
import 'package:flutter/material.dart';
import 'package:flutt_mobile/screen/home/discussion.dart';
import 'package:flutt_mobile/service/getname.dart';

class Chat extends StatefulWidget{
  const Chat({super.key});
  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat>{
  String name ="";
  List friends=[];
  @override
  void initState(){
    super.initState();
    _loadData();
  }
   void _loadData() async {
      Getname.me().then((value){
        setState(() {
        name = value;
      });
      Getname.id().then((value){
        Friend.getFriend(value).then((x){
          setState(() {
            friends = x;
          });
        });
      });
      }
    );
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:  Text(name ,style: const TextStyle(fontWeight: FontWeight.w500),),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child:  Column(
          children: [
            Expanded(
              child: ListView(
                children:[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Messages',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  for(var elem in friends)...[
                    Message(id:elem['id'],name: elem['name'] ,splitedName: elem['splitedName'],),
                  ]
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget{
  
  final int id;
  final String name;
  final String splitedName;

  const Message({super.key, required this.id, required this.name, required this.splitedName});
  @override
  Widget build (BuildContext context){
    return   Align(
      child: TextButton(
          onPressed: () {
            
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  Discussion(id: id,name: name, splitedName: splitedName,),));
          },
          child :  Row(
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: CircleAvatar(
                radius: 35.0,
                child: Text(splitedName, style: const TextStyle(
                  fontSize: 20
                ),),
              ),
            ),
            Column(
              children: [
                Text(name, style: const TextStyle(color: Colors.black),),
              ],
            )
          ],
        ) 
      )
    );
  }
}