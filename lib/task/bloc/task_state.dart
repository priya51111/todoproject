import 'package:equatable/equatable.dart';
import 'package:todoproject/task/model.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<Task> tasks;

  const TaskSuccess({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskFailure extends TaskState {
  final String message;
  const TaskFailure({required this.message} );
  @override
  List<Object> get props => [message];
}
