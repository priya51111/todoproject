import 'dart:convert';

import 'package:http/http.dart' as http;

class MenuRepository{

  Future<List<String>> getMenuList(String userId, String date) async {
    const String getByIdMenuUrl = 'https://app-project-7.onrender.com/api/menu/getbyid/:userId/:date';

    final response = await http.get(Uri.parse(getByIdMenuUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<String> menuList = data.map((menu) => menu['menuName'] as String).toList();
      return menuList;
    } else {
      throw Exception('Failed to load menu list: ${response.body}');
    }
  }


Future<void> addMenu(String menuName) async {
  const   String createMenuUrl = 'https://app-project-7.onrender.com/api/menu/menu';

    final response = await http.post(
      Uri.parse(createMenuUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"menuName": menuName}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add menu: ${response.body}');
    }
  }
}
