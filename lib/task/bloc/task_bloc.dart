import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoproject/task/repository/task_repository.dart';

import '../model.dart';
import 'task_event.dart';
import 'task_state.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final Logger logger = Logger();

  TaskBloc({
    required this.taskRepository,
    required this.localNotificationsPlugin,
  }) : super(TaskInitial()) {
    on<TaskSubmitted>(_ontaskSubmitted);

  }
  Future<void>_ontaskSubmitted(
    TaskSubmitted event,
    Emitter<TaskState> emit,
  ) async{
      emit(TaskLoading());
      logger.i(
          'Creating task: ${event.task}, Time: ${event.time}, Date: ${event.date},UserId: ${event.userId}, MenuId: ${event.menuId}');
    try {
        await taskRepository.createTask(Task(
          task: event.task,
          time: event.time,
          date: event.date,
         userId: event.userId,
         menuId: [],
        ));

        await _scheduleNotification(event.task, event.date, event.time);

        emit(TaskSucess());
        logger.i('Task created successfully and notification scheduled');
      } catch (error) {
        logger.e('Error creating task: $error');
        emit(TaskFailure(message: error.toString()));
      }
  }


  Future<void> _scheduleNotification(
      String task, String date, String time) async {
    var scheduledTime = DateTime.parse('$date $time');

    var tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await localNotificationsPlugin.zonedSchedule(
      0,
      'Task Reminder',
      task,
      tzScheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
