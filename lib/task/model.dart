class Menu {
  final String id;

  Menu({required this.id});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Task {
  final String task;
  final String date;
  final String time;
  final List<Menu> menuId; // List of Menu objects
  final String userId;

  Task({
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    var menuFromJson = json['menuId'] as List;
    List<Menu> menuList = menuFromJson.map((i) => Menu.fromJson(i)).toList();

    return Task(
      task: json['task'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      menuId: menuList,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'date': date,
      'time': time,
      'userId': userId,
      'menuId': menuId.map((menu) => menu.toJson()).toList(),
    };
  }
}

