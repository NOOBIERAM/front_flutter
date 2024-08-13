import 'dart:convert';
import 'package:flutt_mobile/service/config.dart';
import 'package:http/http.dart' as http;
class Friend {
  static Future<List> getPending(int userId) async{
    http.Response resp = await http.get(Uri.parse('$baseUrl/friend/pending/$userId'));
    return jsonDecode(resp.body);
  }
  static Future<List> getFriend(int userId) async{
    http.Response resp = await http.get(Uri.parse('$baseUrl/friend/accepted/$userId'));
    return jsonDecode(resp.body);
  }
  static Future<List> getSuggest(int userId) async{
    http.Response resp = await http.get(Uri.parse('$baseUrl/friend/suggest/$userId'));
    return jsonDecode(resp.body);
  }
  static Future<void> accept(int friendId) async{
      await http.put(Uri.parse('$baseUrl/friend/accept/$friendId'));
  }
  static Future<void> follow(int userId, int friendId ) async{
      Map data = {
        "userId" : userId,
        "friendId" : friendId
      };
      var body = json.encode(data);
      await http.post(Uri.parse('$baseUrl/friend/add'),headers: headers,body: body);
  }
  static Future<int> getFollowersCount(int userId) async{
      http.Response resp = await http.get(Uri.parse('$baseUrl/getFollowers/$userId'));
      return jsonDecode(resp.body);
  }
}