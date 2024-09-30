import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoproject/menu/bloc/menu_bloc.dart';
import 'package:todoproject/menu/bloc/menu_event.dart';
import 'package:todoproject/menu/bloc/menu_state.dart';
import 'package:todoproject/task/bloc/task_bloc.dart';
import 'package:todoproject/task/bloc/task_event.dart';
import 'package:todoproject/task/bloc/task_state.dart';
import 'package:todoproject/task/view/view.dart';

import 'model.dart';

class TaskMenuPage extends StatefulWidget {
  final String userId;

  TaskMenuPage({required this.userId});

  @override
  _TaskMenuPageState createState() => _TaskMenuPageState();
}

class _TaskMenuPageState extends State<TaskMenuPage> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    // Fetch the tasks when the page is first created
    context.read<TaskBloc>().add(FetchTasksByUserId(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.check_circle, size: 30),
            SizedBox(width: 10),
            BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state is MenuLoading) {
                  return CircularProgressIndicator();
                } else if (state is MenuLoaded) {
                  final menuList = state.menuList;
                  return DropdownButton<String>(
                    value: dropdownValue,
                    items: [
                      ...menuList.map((Menus menu) {
                        return DropdownMenuItem<String>(
                          value: menu.menuId,
                          child: Text(menu.menuName),
                        );
                      }).toList(),
                      DropdownMenuItem<String>(
                        value: "New List",
                        child: Text("New List"),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value == "New List") {
                        _showAddMenuDialog(context);
                      } else {
                        setState(() {
                          dropdownValue = value;
                        });
                      }
                    },
                  );
                } else if (state is MenuError) {
                  return Text('Error: ${state.message}');
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      body:BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is TaskSuccess) {
      if (state.tasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/noimage.png', 
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'No tasks available',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      } else {
        return ListView.builder(
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            final task = state.tasks[index];
            final taskDueDate = DateTime.parse(task.date);
            bool isExpired = DateTime.now().isAfter(taskDueDate);

            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(left: task.isChecked ? 100 : 10, top: 10),
              child: task.isChecked
                  ? SizedBox.shrink()
                  : Container(
                      height: 70,
                      width: 370,
                      decoration: BoxDecoration(
                        color: isExpired
                            ? Colors.red
                            : Color.fromARGB(135, 33, 149, 243),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                          value: task.isChecked,
                          onChanged: (bool? value) {
                            if (value != null && value) {
                              context.read<TaskBloc>().add(UpdateTaskStatus(task: task.copyWith(isChecked: value)));
                              _showTaskFinishedDialog(context);
                            }
                          },
                        ),
                        title: Text(
                          task.task,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              isExpired ? 'No due' : '${task.date},',
                              style: TextStyle(color: Colors.white),
                            ),
                            if (!isExpired)
                              Text(
                                ' ${task.time}',
                                style: TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        );
      }
    } else if (state is TaskFailure) {
      return Center(child: Text('Failed to load tasks: ${state.message}'));
    } else {
      return Center(child: Text('No tasks available'));
    }
  },
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to NewTaskPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMenuDialog(BuildContext context) {
    final TextEditingController menuController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Menu Name'),
          content: TextField(
            controller: menuController,
            decoration: InputDecoration(hintText: 'Menu Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final menuName = menuController.text;
                if (menuName.isNotEmpty) {
                  context.read<MenuBloc>().add(AddMenuEvent(menuname: menuName, userId: widget.userId, date: ''));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskFinishedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Finished'),
          content: Text('The task has been marked as completed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
