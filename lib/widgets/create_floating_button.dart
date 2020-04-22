import 'package:flutter/material.dart';
import 'package:will_do/screens/add_todo_screen.dart';

class CreateFloatingButton extends StatelessWidget {
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
              builder: (context) => AddTodoScreen(),
            )
        );
      },
    );
  }
}
