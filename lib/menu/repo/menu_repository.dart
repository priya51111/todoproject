import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model.dart';


class MenuRepository {
     final String createMenuUrl =
        'https://app-project-7.onrender.com/api/menu/menu';
        

  Future<List<Menus>> getMenuList(String userId, String date) async {
    final String getByIdMenuUrl =
        'https://app-project-7.onrender.com/api/menu/getbyid/$userId/$date';

    final response = await http.get(Uri.parse(getByIdMenuUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Menus> menuList = data.map((menu) => Menus.fromJson(menu)).toList();
      return menuList;
    } else {
      throw Exception('Failed to load menu list: ${response.body}');
    }
  }

  Future<String> addMenu(String menuName, String userId, String date) async {
   
    final response = await http.post(
      Uri.parse(createMenuUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "menuName": menuName,
        "userId": userId,
        "date": date,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['menuId']; // Return the menuId
    } else {
      throw Exception('Failed to add menu: ${response.body}');
    }
  }
}
