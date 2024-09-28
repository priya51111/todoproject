import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../model.dart';


class TaskRepository {
  final String apiUrl = 'https://app-project-7.onrender./api/task/createtask';
   final Logger log = Logger();
  Future<void> createTask(Task task) async {
    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode({
            'task': task.task,
            'date': task.date,
            'time': task.time,
            'userId':task.userId,
            'menuId':task.menuId,
          }));
      if (response.statusCode != 200) {
         log.e('Failed to create task: ${response.statusCode}');
        throw Exception('failed to create task');
      }
    } catch (error) {
        log.e('Error creating task: $error');
      throw Exception('Error creating task:$error'); 
    }
  }
}
