import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoproject/menu/bloc/menu_event.dart';

import '../repo/menu_repository.dart';
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
      emit(MenuLoaded(menuList: menuList));
    } catch (e) {
      emit(MenuError(message: 'Failed to fetch menu list'));
    }
  }

  Future<void> _onAddMenu(AddMenuEvent event, Emitter<MenuState> emit) async {
    try {
      await menuRepository.addMenu(event.menuname);
     
      add(FetchMenuListEvent(userId: event.userId, date: event.date));
    } catch (e) {
      emit(MenuError(message: 'Failed to add new menu'));
    }
  }
}
