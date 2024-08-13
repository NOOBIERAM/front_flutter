// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutt_mobile/screen/newaccount.dart';
import 'package:flutt_mobile/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutt_mobile/screen/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget{
  const Register({super.key});
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register>{
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = '';
  String password = '';
  
  loginPressed() async {
      if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    http.Response resp = await AuthService.login(email, password);
    Map reponse = jsonDecode(resp.body);
    setState(() {
      _isLoading = false;
    });

    if(resp.statusCode == 200){
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("id", reponse['id']);
      await prefs.setString("name", reponse['name']);
      await prefs.setString("firstname", reponse['firstname']);
      await prefs.setString("email", reponse['email']);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(reponse.values.first),
          duration: const Duration(seconds: 3),
          ),
      );  
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(220, 2, 1, 1) ,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 25,right: 25, bottom: 16, top: 100),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) => email = value,
                  style: const TextStyle(color: Color.fromARGB(136, 255, 255, 255),fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color.fromARGB(136, 255, 255, 255),fontFamily: "Montserrat", fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty) ?  'Please enter your email' :  null;
                  },
                ),
                TextFormField(
                  onChanged: (value) => password = value,
                  style: const TextStyle(color: Color.fromARGB(136, 255, 255, 255),fontSize: 18),
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Color.fromARGB(136, 255, 255, 255),fontFamily: "Montserrat", fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  validator: (value) {
                    return (value == null || value.isEmpty) ? 'Please enter your password' : null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading ? const CircularProgressIndicator() : ElevatedButton(
                  onPressed: loginPressed, 
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color.fromARGB(220, 2, 1, 1),  fontSize: 18, fontWeight: FontWeight.w600),
                  )
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Newaccount()));
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Color.fromARGB(220, 247, 243, 243),  fontSize: 18, fontWeight: FontWeight.w600)
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}


