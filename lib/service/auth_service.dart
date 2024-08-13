import 'dart:convert';
import 'package:flutt_mobile/service/config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<http.Response> login(String email, String password) async {
    Map data = {"email": email, "password": password};
    var body = json.encode(data);
    var url = Uri.parse('$baseUrl/login');
    http.Response resp = await http.post(url, headers: headers, body: body);
    return resp;
  }
  static Future<http.Response> register(String name, String firstname, String email, String password) async {
    Map data = {
      "name" : name,
      "firstname" : firstname,
      "email" : email,
      "password" : password
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseUrl/register');
    http.Response resp = await http.post(url, headers: headers, body: body);
    return resp;
  }
}
