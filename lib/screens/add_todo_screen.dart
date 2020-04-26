import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/plugins/notifications_plugin.dart';
import 'package:will_do/store/constants.dart';
import 'package:hive/hive.dart';

String _getDisplayedDate (DateTime date) {
  if (date == null) return "";
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final todayDate = DateTime(date.year, date.month, date.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  if (today == todayDate)
    return "Today";
  else if (todayDate == tomorrow)
    return "Tomorrow";
  else if (date.year == now.year)
    return DateFormat.MMMd().format(date);
  return DateFormat.yMMMd().format(date);
}

String _getDisplayedTime (TimeOfDay time) {
  if (time == null) return "";
  final now = DateTime.now();
  final DateTime exampleDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat.Hm().format(exampleDate);
}


class AddTodoScreen extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String _title;
  DateTime _dueDate;
  TimeOfDay _dueTime;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _saveTodo () async {
    Todo newTodo = Todo(
      title: _title,
      dueDate: _dueDate,
      dueTime: _dueTime?.toString(),
    );
    Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
    todoBox.add(newTodo);
    _displaySnackBar("Task successfully created!");
    print("new todo key: ${newTodo.key}");
    if (_dueTime != null) {
      final DateTime dueDateTime = DateTime(_dueDate.year, _dueDate.month, _dueDate.day, _dueTime.hour, _dueTime.minute);
      if (dueDateTime.isAfter(DateTime.now())) {
        await Provider.of<NotificationPlugin>(context, listen: false).scheduleNotification(
          dueDateTime,
          newTodo.key,
          _title,
          "Your task is due now",
        );
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    
    _dateController.text = _getDisplayedDate(_dueDate);
    _timeController.text = _getDisplayedTime(_dueTime);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Task"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    //hintText: "Enter todos title",
                    labelText: "What do you want to do?",
                  ),
                  initialValue: "",
                  onChanged: (val) {
                    setState(() {
                      _title = val;
                    });
                  },
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Day",
                          hintText: "Choose date",
                        ),
                        readOnly: true,
                        controller: _dateController,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Time",
                          hintText: "Today",
                        ),
                        readOnly: true,
                        controller: _timeController,
                        onTap: () => _selectTime(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: RaisedButton(
                        child: Text("Save"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: _saveTodo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        //("time picked: ${_dueTime.toString()}");
        if (_dueTime == null) {
          _selectTime(context);
        }
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    // print("picking, picked: ${picked.toString()}");
    if (picked != null && picked != _dueTime) {
      setState(() {
        _dueTime = picked;
        if (_dueDate == null) {
          _dueDate = DateTime.now();
        }
      });
    }
  }

  void _displaySnackBar (String msg) {
    final snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
