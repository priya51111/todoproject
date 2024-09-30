 import 'package:flutter/material.dart';
class Menus {
  final String menuId;
  final String menuName;
  final String userId;
  final String date;

  Menus({
    required this.menuId,
    required this.menuName,
    required this.userId,
    required this.date,
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      menuId: json['menuId'],
      menuName: json['menuname'],
      userId: json['userId'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuname': menuName,
      'userId': userId,
      'date': date,
    };
  }
}
