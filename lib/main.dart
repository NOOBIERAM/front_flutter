import 'package:flutt_mobile/service/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutt_mobile/screen/home.dart';
import 'package:flutt_mobile/screen/template/login.dart';

void main() {
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 244, 242, 247)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool ifLoggedInValue = true;
  void ifLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ifLoggedInValue  = prefs.containsKey('id');
    });
  }
    @override
  Widget build(BuildContext context) {
    ifLoggedIn();
    return Scaffold(
        body:  ifLoggedInValue ? const Home() : const Login()
    );
  }
}
