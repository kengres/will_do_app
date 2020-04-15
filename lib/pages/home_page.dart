import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/store/todo_data.dart';
import 'package:will_do/widgets/todo_card.dart';
import 'add_todo_page.dart';
import 'todo_page.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  Choice(title: "Change theme", icon: Icons.autorenew)
];

class HomePage extends StatelessWidget {
  final List<Todo> _todos = [];
  //Choice _selectedChoice;

  @override
  Widget build(BuildContext context) {
    final TodoData todoData = Provider.of<TodoData>(context, listen: false);
    todoData.getAllTodos();
    print("[HomePage] build, count ${todoData.todoCount}");

    void onCardTap (int index) {
      print("clicked todo index: $index");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<TodoData>.value(
              value: todoData,
              child: TodoPage(index: index,),
            ),
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.menu),
        title: Text("Will Do"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
            onSelected: (Choice value) {
              print("toggled ${value.title}");
              todoData.clearAll();
              //Provider.of<ThemeChanger>(context, listen: false).toggleTheme();
            }
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
//          color: Color(0xFF3f405a),
        ),
        child: todoData.todoCount > 0 ? todoListWidget(onCardTap) :  emptyListWidget(context),
      ),
      floatingActionButton: CreateFloatingButton(todoData),
    );
  }

  Widget todoListWidget (onCardTap) {
    return Consumer<TodoData>(
      builder: (_, todoData, __) => ListView.builder(
        itemCount: todoData.todoCount,
        itemBuilder: (BuildContext context, int index) {
          final currentTodo = todoData.getTodo(index);
          print("[List] todo $index: ${currentTodo.dueDate}");
          return todoItemCard(
            context,
            currentTodo,
            index,
            _getPriorityColor(currentTodo.priority, context),
            _formatDate(currentTodo.dueDate),
            onCardTap,
          );
        },
      ),
    );
  }

  Widget emptyListWidget (BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.list,
            size: 144.0,
            // todo: add Icon theme
          ),
          Text(
            "You have nothing planned!",
            style: Theme.of(context).textTheme.title.copyWith(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Tap the + icon to add a task.",
            style: Theme.of(context).textTheme.subtitle.copyWith(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor (int priority, BuildContext context) {
    switch (priority) {
      case 1:
        return Colors.green[700];
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red[900];
      default:
        return Theme.of(context).textTheme.body1.color;
    }
  }

  String _formatDate (DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime d = date?? now;
    final DateTime nextYear = DateTime.parse("${DateTime.now().year + 1}-01-01 00:00:00");
    final String todayDateString = DateFormat("yyyy-MM-dd").format(now);
    final String thisDateString = DateFormat("yyyy-MM-dd").format(d);
    final bool isToday = todayDateString == thisDateString;
    if (isToday) {
      return "Today, " + DateFormat("H:mm").format(d);
    }
    return DateFormat(nextYear.isAfter(d) ? "MMMd" : 'yMMMd').format(d);
  }
}

class CreateFloatingButton extends StatelessWidget {
  final TodoData todoData;

  CreateFloatingButton(this.todoData);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<TodoData>.value(
                value: todoData,
                child: AddTodoPage(),
              ),
            )
        );
      },
    );
  }
}
