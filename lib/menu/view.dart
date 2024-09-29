import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoproject/menu/bloc/menu_bloc.dart';
import 'package:todoproject/menu/bloc/menu_event.dart';
import 'package:todoproject/menu/bloc/menu_state.dart';
import 'package:todoproject/task/bloc/task_bloc.dart';
import 'package:todoproject/task/bloc/task_event.dart';
import 'package:todoproject/task/bloc/task_state.dart';
import 'package:todoproject/task/view/view.dart';

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
                      ...menuList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskSuccess) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Container(
                    height: 70,
                    width: 370,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(135, 33, 149, 243),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        value: task.isChecked,
                        onChanged: (bool? value) {
                          context.read<TaskBloc>().add(UpdateTaskStatus(task: task.copyWith(isChecked: value)));
                        },
                      ),
                      title: Text(
                        task.task,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Row(
                        children: [
                          Text('${task.date},', style: TextStyle(color: Colors.white)),
                          Text('${task.time}', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  
                );
              },
            );
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
            MaterialPageRoute(builder: (context) => const CreateTaskPage   ()),
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
}
