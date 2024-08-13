import 'package:flutter/material.dart';

class Rightmessage extends StatelessWidget{
  final String message;
  const Rightmessage ({super.key, required this.message});
  @override
  Widget build (BuildContext context){
    return  Padding(
      padding:  const EdgeInsets.only(left: 150, right: 15, top: 10, bottom: 10),
      child: Container(
        color: Colors.lightBlueAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(message),
        )
      ),
    );
  }
}