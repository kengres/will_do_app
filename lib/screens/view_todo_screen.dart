import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/store/constants.dart';

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

TimeOfDay formatDueTime (String t) {
  //print("formatDueTime: $t");
  if (t == null) {
    return null;
  }
  final String subTime = t.substring(t.indexOf(":") - 2, t.indexOf(":") + 3);
  return TimeOfDay(
    hour: int.parse(subTime.split(":")[0]),
    minute: int.parse(subTime.split(":")[1]),
  );
}

class ViewTodoScreen extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final Todo todo;

  ViewTodoScreen({Key key, this.todo}) : super(key: key);

  @override
  _ViewTodoScreenState createState() => _ViewTodoScreenState();
}

class _ViewTodoScreenState extends State<ViewTodoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _title;
  DateTime _dueDate;
  TimeOfDay _dueTime;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title;
    _title = widget.todo.title;
    _dateController.text = _getDisplayedDate(widget.todo.dueDate);
    _dueDate = widget.todo.dueDate;
    TimeOfDay fDueTime = widget.todo.dueTime != null ? formatDueTime(widget.todo.dueTime) : null;
    _dueTime = fDueTime;
    _timeController.text = _getDisplayedTime(fDueTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit task"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "What do you want to do?",
                  ),
                  controller: _titleController,
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

  void _saveTodo () {
    Todo newTodo = Todo(
      title: _title,
      dueDate: _dueDate,
      dueTime: _dueTime.toString(),
    );
    Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
    print("key: ${widget.todo.key}");
    todoBox.put(widget.todo.key, newTodo);
    _displaySnackBar("Task successfully updated!");
    // Navigator.of(context).pop();
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
        _timeController.text = _getDisplayedTime(picked);
        if (_dueDate == null) {
          _dueDate = DateTime.now();
          _dateController.text = _getDisplayedDate(DateTime.now());
        }
      });
    }
  }

  void _displaySnackBar (String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}
