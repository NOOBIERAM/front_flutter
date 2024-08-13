import 'package:flutt_mobile/service/config.dart';
import 'package:flutter/material.dart';

class Cadran extends StatelessWidget {
  final String texte;
  final String image;
  final String like;

  const Cadran({super.key, required this.texte, required this.image, required this.like});
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
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    texte,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            image!="null"? Image(image: image) : const SizedBox(),
            FootCadran(like: like),
          ],
        ),
      ),
    );
  }
}

class Image extends StatelessWidget{
  final String image;
  const Image ({super.key, required this.image});
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
class FootCadran extends StatelessWidget {
  final String like;
  const FootCadran({super.key, required this.like});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          children: [
            Text(like.toString())
          ],
        ));
  }
}