import 'dart:convert';
import 'package:flutt_mobile/service/config.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static Future<List> getAll(int userId, int friendId) async {
    http.Response resp =
        await http.get(Uri.parse('$baseUrl/message/getAll/$userId/$friendId'));
    return jsonDecode(resp.body);
  }
  static Future<void> send(int userId, int friendId, String content) async {
    Map data = {"senderId": userId, "receiverId": friendId, "content":content};
    var body = json.encode(data);
    await http.post(Uri.parse('$baseUrl/message/send'),
        headers: headers, body: body);
  }
}
