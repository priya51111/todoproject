import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:todoproject/login/bloc/login_event.dart';
import 'package:todoproject/login/bloc/login_state.dart';
import 'package:todoproject/login/model/models.dart';
import 'package:todoproject/login/repository/repository.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final Logger logger = Logger(); 

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<AddUser>(_onAddUser);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final users = await userRepository.fetchUsers();
      await userRepository.saveUserToLocal(users);
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to fetch users'));
      logger.e('Fetch Users Error: $e');
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final users = await userRepository.getUsersFromLocal();
      final newUser = User(
        userId: userRepository.generateUserId(),
        mailId: event.mailId,
        password: event.password,
      );
      users.add(newUser);
      await userRepository.saveUserToLocal(users);
      emit(UserLoaded(users));
      logger.i('User added successfully: ${newUser.toJson()}');
    } catch (e) {
      emit(UserError('Failed to add user'));
      logger.e('Add User Error: $e');
    }
  }
}
