// ignore_for_file: use_build_context_synchronously

import 'package:flutt_mobile/screen/register.dart';
import 'package:flutt_mobile/service/friend_service.dart';
import 'package:flutt_mobile/service/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutt_mobile/service/getname.dart';
import 'package:flutt_mobile/screen/components/cadran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Me extends StatefulWidget {
  const Me({super.key});
  @override
  State<Me> createState() => _Me();
}

class _Me extends State<Me> {
  String name = "";
  int id = 0;
  int followers = 0;
  int posts = 0;
  List allPost = [];
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
      Friend.getFollowersCount(value).then((x) {
        setState(() {
          followers = x;
        });
      });
      Post.getMyPost(value).then((x){
        setState(() {
          allPost = x;
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
                top: 20,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: 'cursive', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.only(top: 20, right: 10),
            child: IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const Register(),));
                },
                icon: const Icon(
                  Icons.exit_to_app_sharp,
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
              Profil(
                followers: followers,
                posts: posts,
              ),
              for(var elem in allPost)...[
                Cadran(texte: elem['content'], image: elem['image'].toString(), like:elem['like'].toString() )
              ]
            ],
          ))
        ],
      ),
    );
  }
}

class Profil extends StatelessWidget {
  final int followers;
  final int posts;
  const Profil({super.key, name, required this.followers, required this.posts});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          const Column(
            children: [
              CircleAvatar(
                radius: 30,
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 29),
              child: Column(
                children: [Text(posts.toString()), const Text('Publication')],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 19),
              child: Column(
                children: [
                  Text(
                    followers.toString(),
                  ),
                  const Text('Followers')
                ],
              )),
        ],
      ),
    );
  }
}
