import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(MenuLoading()) {
    on<FetchMenuListEvent>(_onFetchMenuList);
    on<AddMenuEvent>(_onAddMenu);
  }

  Future<void> _onFetchMenuList(FetchMenuListEvent event, Emitter<MenuState> emit) async {
    try {
      emit(MenuLoading());
      final menuList = await menuRepository.getMenuList(event.userId, event.date);
      emit(MenuLoaded(menuList: menuList)); // Pass the fetched menu list here
    } catch (e) {
      print('Error fetching menu list: $e'); // Logging the error
      emit(MenuError(message: 'Failed to fetch menu list: ${e.toString()}'));
    }
  }

  Future<void> _onAddMenu(AddMenuEvent event, Emitter<MenuState> emit) async {
    try {
      emit(MenuLoading());
      String menuId = await menuRepository.addMenu(event.menuname, event.userId, event.date);
      emit(MenuAdded(menuId: menuId)); // Emit a state indicating the menu was added
    } catch (e) {
      print('Error adding menu: $e'); // Logging the error
      emit(MenuError(message: 'Failed to add menu: ${e.toString()}'));
    }
  }
}
