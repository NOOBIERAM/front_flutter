import 'package:shared_preferences/shared_preferences.dart';

class Getname {
  static Future<String> me() async {
    String name = '';
    final prefs = await SharedPreferences.getInstance();
    String nameI = prefs.getString('name')!;
    String nameII = prefs.getString('firstname')!;
    name = '$nameI $nameII';
    return name;
  }
  static Future<int> id() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id')!;
  }
}
