// ignore_for_file: avoid_print

import 'package:flutt_mobile/service/config.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService with ChangeNotifier {
  late io.Socket socket;

  void connect(int senderId) {
    socket = io.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'senderId': senderId},
    });
    socket.on('connect', (_) => {print('connected')});
    socket.on('disconnect', (_) => {print('disconnected')});
    // socket.on('receiveMessage', (data) => {print('Message : $data')});
    socket.on('receiveMessage', (data) {
      print(data);
      notifyListeners();  // Notify listeners when a new message is received
    });
    // socket.on('notifyPost', (data) {
    //   notifyListeners();  // Notify listeners when a new message is received
    // });
    // socket.on('notifyFriend', (data) {
    //   notifyListeners();  // Notify listeners when a new message is received
    // });
  }

  void joinRoom(int receiverId) {
    socket.emit('join', {'receiverId': receiverId});
  }

  void sendMessage() {
    socket.emit('sendMessage', {'message': ''});
  }
  // void newPost() {
  //   socket.emit('newPost', {'message': ''});
  // }
  // void newFriend() {
  //   socket.emit('newFriend', {'message': ''});
  // }
}
