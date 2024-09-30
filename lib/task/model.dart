

import '../menu/model.dart';

class Task {
  final String task;
  final String date;
  final String time;
  final List<Menus> menuId;
  final String userId;
  bool isChecked; 

  Task({
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,
    required this.userId,
    this.isChecked = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    var menuFromJson = json['menuId'] as List;
    List<Menus> menuList = menuFromJson.map((i) => Menus.fromJson(i)).toList();

    return Task(
      task: json['task'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      menuId: menuList,
      userId: json['userId'] as String,
        isChecked: json['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'date': date,
      'time': time,
      'userId': userId,
      'menuId': menuId.map((menu) => menu.toJson()).toList(),
       'isChecked': isChecked,
    };
  }
  Task copyWith({bool? isChecked}) {
    return Task(
      task: task,
      date: date,
      time: time,
      menuId: menuId,
      userId: userId,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}


