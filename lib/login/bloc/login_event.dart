import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends UserEvent {}

class AddUser extends UserEvent {
  final String mailId;
  final String password;
  const AddUser(this.mailId, this.password);

  @override
  List<Object> get props => [mailId, password];
}
