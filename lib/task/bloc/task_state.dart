import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSucess extends TaskState {}

class TaskFailure extends TaskState {
  final String message;
  const TaskFailure({required this.message} );
  @override
  List<Object> get props => [message];
}
