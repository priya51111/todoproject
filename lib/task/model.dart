class Menu {
  final String menuId;

  Menu({required this.menuId});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menuId: json['menuId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
    };
  }
}

class Task {
  final String task;
  final String date;
  final String time;
  final List<Menu> menuId;
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
    List<Menu> menuList = menuFromJson.map((i) => Menu.fromJson(i)).toList();

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


