// createtask.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';



class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final List<String> repeatOptions = [
    'No repeat',
    'Once a day',
    'Once a week',
    'Once a month',
    'Once a year'
  ];
  final List<String> taskTypes = ['Default', 'Personal', 'Shopping', 'Work'];

  String selectedRepeat = 'No repeat';
  String selectedTaskType = 'Default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(135, 33, 149, 243),
        title: Text('New Task', style: TextStyle(color: Colors.white)),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskSucess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task Created Successfully')),
            );
            Navigator.pop(context); // Go back after success
          } else if (state is TaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task Creation Failed: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                // Task Input
                Text(
                  "What is to be done?",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _taskController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter Task here",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Date Input
                Text(
                  "Due Date",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _dateController,
                  style: TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue.shade900,
                              onPrimary: Colors.white,
                              onSurface: Colors.blue.shade900,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Date not set",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Time Input
                Text(
                  "Time",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _timeController,
                  style: TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue.shade900,
                              onPrimary: Colors.white,
                              onSurface: Colors.blue.shade900,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      _timeController.text = pickedTime.format(context);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Time not set",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.access_time, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),

              
                Text(
                  "Repeat",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedRepeat,
                  dropdownColor: Color.fromARGB(135, 33, 149, 243),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRepeat = newValue!;
                    });
                  },
                  items: repeatOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Task Type Dropdown
                Text(
                  "Add to List",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedTaskType,
                  dropdownColor: Color.fromARGB(135, 33, 149, 243),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTaskType = newValue!;
                    });
                  },
                  items: taskTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),

              
                Center(
                  child: FloatingActionButton(
                    onPressed: () {
                      final task = _taskController.text;
                      final date = _dateController.text;
                      final time = _timeController.text;

                      if (task.isEmpty || date.isEmpty || time.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields')),
                        );
                      } else {
                        
                        context.read<TaskBloc>().add(   TaskSubmitted(
                              task: task,
                              date: date,
                              time: time,
                             
                              menuId: [], userId: '',
                            ));
                      }
                    },
                    child: Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
