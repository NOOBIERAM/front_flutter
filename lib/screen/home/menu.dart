// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutt_mobile/service/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutt_mobile/screen/home/chat.dart';
import 'package:flutt_mobile/screen/home/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutt_mobile/screen/components/cadranpub.dart';
import 'package:flutt_mobile/service/getname.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  State<Menu> createState() => _Menu();
}
class _Menu extends State<Menu> {
  File? _selectedFile;
  String content = '';
  String name = ''; 
  int userId = 0;
  List post = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }
  void _showMyDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width *0.8, // 80% de la largeur de l'écran
            height: MediaQuery.of(context).size.height *0.8, // 80% de la hauteur de l'écran
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Form(
                      child: TextField(
                    onChanged: (value) => content = value,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quoi de neuf?',
                    ),
                  )),
                  ),
                  
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                   IconButton(
                    onPressed: (){
                      _pickFile();
                    },
                    icon: const Icon(Icons.upload),
                  ),
                  IconButton(
                    onPressed: () async {
                      if(content.isNotEmpty || _selectedFile != null)
                      {
                        if((content.isNotEmpty && _selectedFile != null) || (content.isEmpty && _selectedFile != null) ) {
                          await Post.addPostWithImage(_selectedFile!,id, content);
                        }
                        if(content.isNotEmpty && _selectedFile == null){
                          await Post.addPost(id, content);
                        }
                        content ='';
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }  
  void _loadData() async {
    Getname.me().then((value) {
      setState(() {
        name = value;
      });
    });
    Getname.id().then((value) {
      Post.getFriendPost(value).then((x){
        setState(() {
          userId = value;
          post = x;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 2,
              ),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'E-Resaka',
                  style: TextStyle(
                      fontFamily: 'cursive', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.only(top: 2, right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notif(),
                      ));
                },
                icon: const Icon(
                  Icons.notifications_none,
                  size: 30,
                )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 2, right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Chat(),
                      ));
                },
                icon: const Icon(
                  Icons.messenger_outline_rounded,
                  size: 30,
                )),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              for(var elem in post )...[
                Cadranpub(postId:elem['id'],userId:userId,name : elem['name'],texte: elem['content'], image: elem['postImage'].toString(), like: elem['like'].toString(),splitedName:elem['splitedName']),
              ]
            ],
          )),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 8, right: 8),
            child: FloatingActionButton(
              backgroundColor: (const Color.fromARGB(255, 16, 211, 104)),
              hoverColor: (const Color.fromARGB(255, 216, 79, 69)),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                int id = await prefs.getInt("id")!;
                _showMyDialog(context, id);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}