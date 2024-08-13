// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutt_mobile/screen/template/register.dart';
import 'package:flutt_mobile/service/auth_service.dart';
import 'package:flutt_mobile/screen/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Login extends StatefulWidget{
  const Login({super.key});
  @override
  State<Login> createState() => _Login();
}
class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;


    loginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    http.Response resp = await AuthService.login(emailController.text, passwordController.text);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 200.0),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                    },
                    child: const Text("New account ?"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
