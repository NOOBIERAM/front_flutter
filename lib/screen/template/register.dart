// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutt_mobile/screen/home.dart';
import 'package:flutt_mobile/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutt_mobile/screen/template/login.dart';

class Register extends StatefulWidget{
  const Register({super.key});
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
    loginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    http.Response resp = await AuthService.register( nameController.text,  firstnameController.text,  emailController.text,  passwordController.text);
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
        const SnackBar(
          content: Text('Erreur de connexion'),
          duration: Duration(seconds: 3),
          ),
      );  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100.0),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                        return (value == null || value.isEmpty) ?  'Please enter your Name' :  null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
                      labelText: 'Firstname',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                        return (value == null || value.isEmpty) ?  'Please enter your Firstname' :  null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                        return (value == null || value.isEmpty) ?  'Please enter your email' :  null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return (value == null || value.isEmpty) ? 'Please enter your password' : null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _isLoading ? const CircularProgressIndicator() : ElevatedButton(
                    onPressed: loginPressed,
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: const Text("Already have an account ?"),
                  ),
                ],
              ),
            ), 
          ],
        ),
      ),
    );
  }
}