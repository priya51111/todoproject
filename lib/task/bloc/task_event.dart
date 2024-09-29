import 'package:equatable/equatable.dart';
import 'package:todoproject/screens.dart/homepage.dart';
import 'package:todoproject/task/model.dart';


abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskSubmitted extends TaskEvent {
  final String task;
  final String date;
  final String time;
  final List<String> menuId;
  final String userId;

  const TaskSubmitted({
    required this.task,
    required this.date,
    required this.time,
     required  this.menuId,
     required this.userId,  
  }
  );

  @override
  List<Object?> get props => [task, date, time, menuId, userId];
}

class FetchTasksByUserId extends TaskEvent {
  final String userId;

  const FetchTasksByUserId({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateTaskStatus extends TaskEvent {
  final Task task;

  const UpdateTaskStatus({required this.task});

  @override
  List<Object?> get props => [task];
}
