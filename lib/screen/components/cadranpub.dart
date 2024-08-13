import 'package:flutt_mobile/service/config.dart';
import 'package:flutt_mobile/service/post_controller.dart';
import 'package:flutter/material.dart';

class Cadranpub extends StatelessWidget {
  final String texte;
  final String image;
  final String like;
  final int userId;
  final int postId;
  final String name;
  final String splitedName;
  const Cadranpub({super.key, required this.name, required this.texte, required this.image, required this.like, required this.splitedName, required this.userId, required this.postId});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: Card(
        color: Colors.white,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
              Padding(
              padding:  const EdgeInsets.all( 15),
              child: Row(
                children: [
                    CircleAvatar(
                    radius: 21,
                    child: Text(splitedName,
                    style: const TextStyle(
                      fontSize: 20
                    ),),
                  ),
                   const SizedBox(
                    width: 8,
                  ),
                   Text(
                    name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                   const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding:const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  texte,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20,),
            image!="null"? ImagePub(image: image) : const SizedBox(),
            FootCadran( userId: userId, postId:postId)
          ],
        ),
      ),
    );
  }
}

class ImagePub extends StatelessWidget{
  final String image;
  const ImagePub ({super.key, required this.image});
  @override
  Widget build (BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0),
        width: 300.0,
        height: 250.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("$baseUrl/$image"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}
class FootCadran extends StatefulWidget {
  final int userId, postId;
  const FootCadran({super.key, required this.userId, required this.postId});

  @override
  State<FootCadran> createState() => _FootCadranState();
}

class _FootCadranState extends State<FootCadran> {
  String like = '';
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    _loadData();
  }  
  void _loadData() async {
    
    await Post.getPostCount(widget.postId,widget.userId).then((value){
      setState(() {
        isLiked = value[0]['isLiked'];
        like = value[0]['likeAmount'].toString();
      });
    });
  }
  void refresh()=> _loadData();
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          children: [
            IconButton(
              onPressed: () async{
                await Post.like(widget.postId, widget.userId);
                refresh();
              },
              icon: Icon(
                isLiked ? Icons.favorite_rounded : Icons.favorite_border,
                size: 30,
              ),
            ),
            Text(
              like,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            )
          ],
        ));
  }
}
