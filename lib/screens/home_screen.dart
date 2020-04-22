import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/screens/view_todo_screen.dart';
import 'package:will_do/store/constants.dart';
import 'package:will_do/widgets/create_floating_button.dart';
import 'package:will_do/widgets/empty_todo.dart';

TimeOfDay getTimeFromString (String t) {
  final String subTime = t.substring(t.indexOf(":") - 2, t.indexOf(":") + 3);
  return TimeOfDay(
    hour: int.parse(subTime.split(":")[0]),
    minute: int.parse(subTime.split(":")[1]),
  );
}

bool _isOverDue (Todo todo) {
  if (todo.isDone) return false;
  if (todo.dueDate == null) return false;
  DateTime d = DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day, 23, 59);
  if (todo.dueTime != null) {
    TimeOfDay t = getTimeFromString(todo.dueTime);
    d = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }
  final DateTime now = DateTime.now();
  final DateTime todayStart = DateTime(now.year, now.month, now.day);
  return d.isBefore(todayStart);
}

int _dueDateCompare (DateTime a, DateTime b, String x, String y) {
  if (a == null) return 1;
  if (b == null) return -1;
  DateTime aa = DateTime(a.year, a.month, a.day, 23, 59);
  if (x != null) {
    TimeOfDay t = getTimeFromString(x);
    aa = DateTime(a.year, a.month, a.day, t.hour, t.minute);
  }
  DateTime bb = DateTime(b.year, b.month, b.day, 23, 59);
  if (y != null) {
    TimeOfDay t = getTimeFromString(y);
    bb = DateTime(b.year, b.month, b.day, t.hour, t.minute);
  }
  return aa.compareTo(bb);
}

String _formatDate (DateTime date, String t) {
  //print("formatting date: ${date.toString()}");
  if (date == null) return "";

  final DateTime now = DateTime.now();
  final DateTime d = date?? now;
  final DateTime nextYear = DateTime.parse("${DateTime.now().year + 1}-01-01 00:00:00");
  final DateTime todayStart = DateTime(now.year, now.month, now.day);
  final DateTime tomorrowStart = DateTime(now.year, now.month, now.day + 1);
  final DateTime thisDateStart = DateTime(d.year, d.month, d.day);


  if (thisDateStart == todayStart) {
    if (t == null) {
      return "Today";
    }
    final String subTime = t.substring(t.indexOf(":") - 2, t.indexOf(":") + 3);
    TimeOfDay time = TimeOfDay(
      hour: int.parse(subTime.split(":")[0]),
      minute: int.parse(subTime.split(":")[1]),
    );
    final DateTime dd = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat("HH:mm").format(dd);
  } else if (thisDateStart == tomorrowStart) {
    if (t == null) {
      return "Tomorrow";
    }
    final String subTime = t.substring(t.indexOf(":") - 2, t.indexOf(":") + 3);
    TimeOfDay time = TimeOfDay(
      hour: int.parse(subTime.split(":")[0]),
      minute: int.parse(subTime.split(":")[1]),
    );
    final DateTime dd = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "Tom, ${DateFormat("HH:mm").format(dd)}";
  }
  return DateFormat(nextYear.isAfter(d) ? "MMMd" : 'yMMMd').format(d);
}

class HomeScreen extends StatelessWidget {
  static const String _okText = "OK";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Will Do"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>(todoBoxName).listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty) {
            return emptyTodoList(context);
          }
          //print("we have ${box.values.length} todos");
          List<Todo> todos = box.values.toList().cast<Todo>();
          todos.sort((a, b) => _dueDateCompare(a.dueDate, b.dueDate, a.dueTime, b.dueTime));

          List<Todo> allTodos = todos.where((t) => !t.isDone).toList();
          //print("we have ${allTodos.length} no done todos");

          List<Todo> overdueTodos = allTodos.where((t) => _isOverDue(t)).toList();
          //print("we have ${overdueTodos.length} overdue todos");

          List<Todo> futureTodos = allTodos.where((t) => !_isOverDue(t)).toList();
          //print("we have ${futureTodos.length} future todos");

          List<Todo> doneTodos = todos.where((t) => t.isDone).toList();
          //print("we have ${doneTodos.length} done todos");

          return ListView.builder(
            itemCount: box.values.length + 3,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (BuildContext context, int index) {
              //print("index is: $index");

              if (index == 0) {
                return interTaskTitle(
                  color: Theme.of(context).secondaryHeaderColor,
                  isEmpty: overdueTodos.length == 0,
                  title: "Overdue",
                );
              }

              if (index == overdueTodos.length + 1) {
                return interTaskTitle(
                  color: Theme.of(context).secondaryHeaderColor,
                  isEmpty: (allTodos.length - overdueTodos.length) == 0,
                  title: "To be done",
                );
              }

              if (index == (overdueTodos.length + futureTodos.length + 2)) {
                return interTaskTitle(
                  color: Theme.of(context).secondaryHeaderColor,
                  isEmpty: futureTodos.length == 0,
                  title: "Completed",
                );
              }

              Todo currentTodo;
              bool isOverdue = false;
              if (index < overdueTodos.length + 1) {
                currentTodo = overdueTodos[index - 1];
                isOverdue = true;
              } else if (index < overdueTodos.length + futureTodos.length + 2) {
                currentTodo = futureTodos[index - (overdueTodos.length + 2)];
              } else {
                currentTodo = doneTodos[index - (overdueTodos.length + futureTodos.length + 3)];
              }
              Color titleColor = Theme.of(context).textTheme.title.color;
              return _todoTile(currentTodo, titleColor, context, isOverdue);
            },
          );
        },
      ),
      floatingActionButton: CreateFloatingButton(),
    );
  }

  Widget _todoTile (Todo todo, Color titleColor, BuildContext context, bool isOverdue) {
    bool done = todo.isDone;
    Color color = done ? Colors.grey[400] : titleColor;
    return ListTile(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                //color: Colors.white,
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: <Widget>[
                  menuListTile(
                    context: context,
                    title: "Edit",
                    icon: Icons.edit,
                    color: Colors.blue[400],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewTodoScreen(todo: todo,),
                        ),
                      );
                    }
                  ),
                  menuListTile(
                    context: context,
                    title: "Mark ${todo.isDone ? "Not" : ""} Done",
                    icon: todo.isDone ? Icons.clear : Icons.check,
                    color: Colors.purple[400],
                    onTap: () {
                      Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
                      todo.isDone = !done;
                      todoBox.put(todo.key, todo);
                    }
                  ),
                  menuListTile(
                    context: context,
                    title: "Delete",
                    icon: Icons.delete,
                    color: Colors.red[400],
                    isLast: true,
                    onTap: () async {
                      final String picked = await _deleteDialog(context);
                      print("[Dialog] picked $picked");
                      if (picked == _okText) {
                        Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
                        todoBox.delete(todo.key);
                      }
                    }
                  ),
                ],
              ),
            );
          },
        );
      },
      leading: InkWell(
        child: Icon(
          done ? Icons.check_box : Icons.check_box_outline_blank,
          color: isOverdue ? Colors.red[400] : color,
        ),
        onTap: () {
          Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
          todo.isDone = !done;
          todoBox.put(todo.key, todo);
        },
      ),
      title: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewTodoScreen(todo: todo,),
              ),
          );
        },
        child: Text(
          todo.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
      trailing: Text(
        _formatDate(todo.dueDate, todo.dueTime),
        style: TextStyle(color: isOverdue ? Colors.red[400] : color),
      ),
    );
  } // _todoTile

  Widget interTaskTitle ({
    bool isEmpty,
    String title,
    Color color,
    double marginBottom = 10,
  }) {
    return isEmpty ? Container() : Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.only(top: 10, bottom: marginBottom),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Text("$title:"),
    );
  }

  Widget menuListTile({
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    bool isLast = false,
    Function onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(title, style: TextStyle(color: color),),
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) {
          onTap();
        }
      },
    );
  }

  Future<String> _deleteDialog(BuildContext context) async {
    return await showDialog<String>(
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
                child: Text(_okText),
                onPressed: () => Navigator.pop(context, _okText),
              ),
            ],
          );
        }
    );
//    if (picked == _okText) {
//      print("[Dialog] picked $picked");
//      Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
//      todoBox.delete(todo.key);
//      //todoData.deleteTodo(currentTodo.key);
//      //Navigator.of(context).pop();
//    }
  }

}
