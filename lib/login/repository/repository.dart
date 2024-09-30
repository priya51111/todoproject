import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todoproject/login/model/models.dart';

class UserRepository {
  final String apiUrl = 'https://app-project-7.onrender.com/api/login'; 
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<void> saveUserToLocal(List<User> users) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userList = users.map((user) => json.encode(user.toJson())).toList();
    await prefs.setStringList('users', userList);
  }

  Future<List<User>> getUsersFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('users');
    if (userList != null) {
      return userList.map((userStr) => User.fromJson(json.decode(userStr))).toList();
    }
    return [];
  }

  String generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
