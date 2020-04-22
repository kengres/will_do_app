import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/screens/view_todo_screen.dart';
import 'package:will_do/store/constants.dart';
import 'package:will_do/widgets/create_floating_button.dart';
import 'package:will_do/widgets/empty_todo.dart';

int _dueDateCompare (DateTime a, DateTime b) {
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}

String _formatDate (DateTime date, String t) {
  //print("formatting date: ${date.toString()}");
  if (date == null) return "";

  final DateTime now = DateTime.now();
  final DateTime d = date?? now;
  final DateTime nextYear = DateTime.parse("${DateTime.now().year + 1}-01-01 00:00:00");
  final String todayDateString = DateFormat("yyyy-MM-dd").format(now);
  final String thisDateString = DateFormat("yyyy-MM-dd").format(d);
  final bool isToday = todayDateString == thisDateString;
  if (isToday) {
    final String subTime = t.substring(t.indexOf(":") - 2, t.indexOf(":") + 3);
    TimeOfDay time = TimeOfDay(
      hour: int.parse(subTime.split(":")[0]),
      minute: int.parse(subTime.split(":")[1]),
    );
    final DateTime dd = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat("HH:mm").format(dd);
  }
  return DateFormat(nextYear.isAfter(d) ? "MMMd" : 'yMMMd').format(d);
}

class HomeScreen extends StatelessWidget {
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
          todos.sort((a, b) => _dueDateCompare(a.dueDate, b.dueDate));
          List<Todo> allTodos = todos.where((t) => !t.isDone).toList();
          //print("we have ${allTodos.length} active todos");
          List<Todo> doneTodos = todos.where((t) => t.isDone).toList();
          //print("we have ${doneTodos.length} done todos");
          return ListView.builder(
            itemCount: box.values.length + 1,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              //print("index is: $index");
              if (index == allTodos.length) {
                //print("getting done title");
                return doneTodos.length > 0 ? completedTitle(context) : Container();
              }
              Todo currentTodo;
              if (index < allTodos.length) {
                currentTodo = allTodos[index];
              } else {
                currentTodo = doneTodos[0];
              }
              Color titleColor = Theme.of(context).textTheme.title.color;
              return _todoTile(currentTodo, titleColor, context);
            },
          );
        },
      ),
      floatingActionButton: CreateFloatingButton(),
    );
  }

  Widget _todoTile (Todo todo, Color titleColor, BuildContext context) {
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
                    onTap: () {
                      Box<Todo> todoBox = Hive.box<Todo>(todoBoxName);
                      todoBox.delete(todo.key);
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
          color: color,
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
        style: TextStyle(color: color),
      ),
    );
  } // _todoTile

  Widget completedTitle (BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: Text("Completed:"),
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

}
