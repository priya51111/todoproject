abstract class MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<String> menuList;

  MenuLoaded({required this.menuList});
}

class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
