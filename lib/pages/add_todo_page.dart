import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/store/todo_data.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String _title;
  DateTime _dueDate;

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final TextEditingController _todoDate = TextEditingController();

  String _displayedDate (DateTime date, TimeOfDay time) {
    DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat.yMMMd().add_Hm().format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
    _todoDate.text = _displayedDate(_date, _time);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        _dueDate = picked;
      });
    }
    _selectTime(context);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _todoDate.text = _displayedDate(_date, _time);
        _dueDate = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
      });
    }
  }

  void _saveTodo () {
    if (_title == null)
      return _displaySnackBar("Please enter a title");
    if (_dueDate == null)
      return _displaySnackBar("Please choose a time");

    Todo newTodo = Todo(
      title: _title,
      dueDate: _dueDate,
    );
    Provider.of<TodoData>(context, listen: false).addTodoItem(newTodo);
    _displaySnackBar("Added todo");
    Navigator.of(context).pop();
  }

  void _displaySnackBar (String msg) {
    final snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Task"),
        actions: <Widget>[
          IconButton(
            iconSize: 20,
            icon: Icon(Icons.check),
            onPressed: _saveTodo,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: "Enter todo title",
                labelText: "Title",
              ),
              onChanged: (val) {
                setState(() {
                  _title = val;
                });
              },
            ),
            SizedBox(height: 10,),
            /* Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Today"),
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text("Tomorrow"),
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text("Another day"),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2016),
                        lastDate: DateTime(2030),
                      );
                    },
                  ),
                ],
              ), */
            //SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                hintText: "Today at 2:00PM",
                labelText: "When",
              ),
              readOnly: true,
              controller: _todoDate,
              onTap: () => _selectDate(context),
            ),
            /* SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  DropdownButton<int>(
                    value: 1,
                    items: _priorityItems,
                    onChanged: (val) {},
                  ),
                ],
              ),*/
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.clear),
                  label: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 10,),
                // todo show if title, disabled otherwise
                RaisedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("Save"),
                  color: Theme.of(context).textTheme.body2.color,
                  textColor: Theme.of(context).textTheme.display1.color,
                  onPressed: _saveTodo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
