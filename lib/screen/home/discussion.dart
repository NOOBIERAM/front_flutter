// ignore_for_file: use_build_context_synchronously

import 'package:flutt_mobile/service/getname.dart';
import 'package:flutt_mobile/service/message_service.dart';
import 'package:flutt_mobile/service/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutt_mobile/screen/components/leftmessage.dart';
import 'package:flutt_mobile/screen/components/rightmessage.dart';
import 'package:provider/provider.dart';

class Discussion extends StatefulWidget{
  final int id;
  final String name;
  final String splitedName;
  const Discussion({super.key, required this.name, required this.splitedName, required this.id});
  @override
  State<Discussion> createState() => _Discussion(); 
}

class _Discussion extends State<Discussion> {
  int userId=0;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List message=[];

  @override
  void initState(){
    super.initState();
    _loadData();
    _initializeSocket();
  }

  void _loadData() async {
     Getname.id().then((value){
        userId = value;
        MessageService.getAll(value,widget.id).then((x){
          setState(() {
            message = x;
          });
        });
      });
      _scrollToBottom();
  }

  void _initializeSocket() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.joinRoom(widget.id); 
    socketService.socket.on('receiveMessage', (data){
      setState(() {
        refresh();
      });
    });
    _scrollToBottom();
  }
  void refresh(){
    _loadData();
  }
  void _scrollToBottom(){
    if(_scrollController.hasClients){
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration : const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, child){
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  child: Text(
                    widget.splitedName,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    for(var elem in message)...[
                      elem['senderId'] == widget.id?
                      Leftmessage(message: elem['content'])
                      : Rightmessage(message: elem['content'])
                    ]
                    
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await MessageService.send(userId, widget.id, _controller.text);
                          final socketService = Provider.of<SocketService>(context, listen: false);
                          socketService.sendMessage();
                          _controller.clear();
                          refresh();
                        },
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
      }
    );
  }
  @override
  void dispose(){
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
