import 'package:flutter/material.dart';

Widget emptyTodoList (BuildContext context) {
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