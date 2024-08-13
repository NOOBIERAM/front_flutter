// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutt_mobile/service/config.dart';

import 'package:http/http.dart' as http;

class Post {
  static Future<List> getPostCount(int postId, int userId) async {
    http.Response resp = 
        await http.get(Uri.parse('$baseUrl/post/like/count/$postId/$userId'));
    return jsonDecode(resp.body);
  }

  static Future<void> addPostWithImage(File file , int userId, String content) async {
    final uri = Uri.parse('$baseUrl/post/add');

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', file.path,
        filename: "upload.jpg"));

    request.fields['content'] = content;
    request.fields['userId'] = userId.toString();

    try {
      await request.send();
    } catch (e) {
      print(e);
    }
  }
  static Future<void> addPost(int userid, String content) async {
    Map data = {"userId": userid, "content": content};
    var body = json.encode(data);
    await http.post(Uri.parse('$baseUrl/post/add'),
        headers: headers, body: body);
    
  }

  static Future<List> getMyPost(int userId) async {
    http.Response resp =
        await http.get(Uri.parse('$baseUrl/post/getAllPost/$userId'));
    return jsonDecode(resp.body);
  }

  static Future<List> getFriendPost(int userId) async {
    http.Response resp =
        await http.get(Uri.parse('$baseUrl/post/getFriendPost/$userId'));
    return jsonDecode(resp.body);
  }

  static Future<void> like(int postId, int userId) async {
    Map data = {"postId": postId, "userId": userId};
    var body = json.encode(data);
    await http.post(Uri.parse('$baseUrl/post/like'),
        headers: headers, body: body);
  }

  static Future<bool> isLiked(int postId, int userId) async {
    Map data = {"postId": postId, "userId": userId};
    var body = json.encode(data);
    http.Response resp = await http.post(Uri.parse('$baseUrl/post/like/status'),
        headers: headers, body: body);
    return jsonDecode(resp.body);
  }
}
