import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/store/todo_data.dart';


class TodoPage extends StatefulWidget {
  final int index;

  const TodoPage({Key key, this.index}) : super(key: key);

    @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  static const String _okText = "OK";
  Todo currentTodo;
  TodoData todoData;

  DateTime _date;
  TimeOfDay _time;

  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

//  @override
//  void initState() {
//    super.initState();
//  }
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    print("[DChD]");
    todoData = Provider.of<TodoData>(context, listen: false);
    currentTodo = todoData.getTodo(widget.index);
    _titleController.text = currentTodo.title;
    _date = currentTodo.dueDate;
    _time = TimeOfDay.fromDateTime(currentTodo.dueDate);
    TimeOfDay todoTime = TimeOfDay.fromDateTime(currentTodo.dueDate);
    _dueDateController.text = _displayedDate(currentTodo.dueDate, todoTime);
  }

  String _displayedDate (DateTime date, TimeOfDay newTime) {
    print("===== $newTime");
    TimeOfDay time = newTime ?? TimeOfDay.now();
    DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat.yMMMd().add_Hm().format(dateTime);
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
        _dueDateController.text = _displayedDate(_date, _time);
      });
    }
  }

  Future<Null> _deleteDialog(BuildContext context) async {
    final String picked = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Deleting this task is irreversible!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context, "Cancel"),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context, _okText),
            ),
          ],
        );
      }
    );
    if (picked == _okText) {
      print("[Dialog] picked $picked");
      todoData.deleteTodo(currentTodo.key);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("[build] dueDate: ${currentTodo.dueDate.toString()}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit task"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter todo title",
                  labelText: "Title",
                  suffixIcon: Icon(Icons.edit, size: 18.0,),
                ),
                controller: _titleController,
                //onSubmitted: (val) => setState(() => _title = val),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "tap to select a date",
                  labelText: "When",
                  suffixIcon: Icon(Icons.edit, size: 18.0,),
                ),
                readOnly: true,
                controller: _dueDateController,
                onTap: () {
                  print("here we show the time date dialog");
                  _selectDate(context);
                },
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                    color: Colors.red[700],
                    textColor: Theme.of(context).textTheme.display1.color,
                    onPressed: () => _deleteDialog(context),
                  ),
                  SizedBox(width: 10,),
                  RaisedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("Save"),
                    color: Theme.of(context).textTheme.body2.color,
                    textColor: Theme.of(context).textTheme.display1.color,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
