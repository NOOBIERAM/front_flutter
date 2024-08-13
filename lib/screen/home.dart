import 'package:flutt_mobile/service/getname.dart';
import 'package:flutt_mobile/service/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutt_mobile/screen/home/menu.dart';
import 'package:flutt_mobile/screen/profil/me.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  
  int _currentIndex = 0;
  int id = 0;
  
  final List<Widget> _tabs = [
    const Center(child: Menu()),
    const Center(child: Me()),
  ];

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }
  void _initializeSocket() {
    final socketService = Provider.of<SocketService>(context, listen: false); 
    Getname.id().then((value) {
      socketService.connect(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 244, 242, 247)),
      ),
      home: Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: '', tooltip: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: '', tooltip: 'Profil'),
          ],
        ),
      ),
    );
  }
}
