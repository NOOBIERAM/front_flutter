import 'package:flutter/material.dart';

class Leftmessage extends StatelessWidget{
  final String message;
  const Leftmessage ({super.key, required this.message});
  @override
  Widget build (BuildContext context){
    return  Padding(
      padding:  const EdgeInsets.only(left: 15, right: 150, top: 10, bottom: 10),
      child: Container(
        color: const Color.fromARGB(255, 202, 202, 202),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(message),
        )
      ),
    );
  }
}