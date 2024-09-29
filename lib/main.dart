import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoproject/menu/repo/menu_repository.dart';
import 'package:todoproject/menu/view.dart';

import 'task/bloc/task_bloc.dart';
import 'task/repository/task_repository.dart';

import 'menu/bloc/menu_bloc.dart';


final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await localNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TaskRepository()),
        RepositoryProvider(create: (context) => MenuRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: context.read<TaskRepository>(),
              localNotificationsPlugin: localNotificationsPlugin,
            ),
          ),
          BlocProvider(
            create: (context) => MenuBloc(
              menuRepository: context.read<MenuRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Task Management App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: TaskMenuPage(userId: '123',),
        ),
      ),
    );
  }
}
