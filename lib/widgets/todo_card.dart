import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/store/todo_data.dart';

Widget todoItemCard(
    BuildContext context,
    Todo todo,
    int index,
    Color priorityColor,
    String date,
    onTapCard) {
  Color titleColor = Theme.of(context).textTheme.title.color;

  void _onDelete() {
    Provider.of<TodoData>(context, listen: false).deleteTodo(todo.key);
  }

  void _onToggleDone() {
    Provider.of<TodoData>(context, listen: false).toggleDone(todo.key);
  }

  return Card(
    elevation: 5.0,
    margin: EdgeInsets.only(bottom: 15),
    child: Container(
      //decoration: BoxDecoration(color: Colors.blue),
      //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //decoration: BoxDecoration(color: Colors.yellow),
            padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
            //margin: EdgeInsets.only(right: 14),
            child: GestureDetector(
              child: Icon(
                todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: todo.isDone ? Colors.grey[500] : priorityColor,
              ),
              onTap: () {
                print("clicked checkbox $index");
                Provider.of<TodoData>(context, listen: false).toggleDone(todo.key);
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                padding: EdgeInsets.fromLTRB(0, 10, 14, 10),
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${todo.title}",
                            style: Theme.of(context).textTheme.title.copyWith(
                              fontSize: 16.0
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            date,
                            style: TextStyle(
                                color: titleColor
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.alarm_on, size: 16, color: priorityColor),
                              SizedBox(width: 3),
                              Icon(Icons.autorenew, size: 16, color: priorityColor),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => onTapCard(index),
              onLongPress: () {
                print("on long press");
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      height: 180,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("Edit"),
                            onTap: () {
                              Navigator.pop(context);
                              onTapCard(index);
                            },
                          ),
                          ListTile(
                            leading: Icon(todo.isDone ? Icons.clear : Icons.check),
                            title: Text("Mark ${todo.isDone ? "Not" : ""} Done"),
                            onTap: () {
                              Navigator.pop(context);
                              _onToggleDone();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                            onTap: () {
                              Navigator.pop(context);
                              _onDelete();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}