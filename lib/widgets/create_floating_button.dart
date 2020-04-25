import 'package:flutter/material.dart';
import 'package:will_do/screens/add_todo_screen.dart';
import 'package:will_do/screens/test_notification_screen.dart';

class CreateFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 36,
          width: 36,
          child: FittedBox(
            child: FloatingActionButton(
              tooltip: "Notification",
              heroTag: "button 2",
              child: Icon(Icons.notifications,),
              onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) {
                       return TestNotificationScreen();
                     }
                   ),
                 );
              }
            ),
          ),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          heroTag: "button 1",
          backgroundColor: Theme.of(context).primaryColor,
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  
                  builder: (context)  {
                    return AddTodoScreen();
                  },
                )
            );
          },
        ),
      ],
    );
  }
}
