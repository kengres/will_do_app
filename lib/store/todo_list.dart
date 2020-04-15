

import 'package:will_do/models/todo.dart';

List<Todo> getTodoSample () => [
    Todo(title: "Have lunch with Sean", dueDate: DateTime.parse("2020-04-02 13:15")),
    Todo(
        title: "Read Flutter documentation",
        dueDate: DateTime.parse("2020-04-20"),
        isDone: true,
    ),
    Todo(title: "Watch the witcher", dueDate: DateTime.parse("2020-06-12")),
    Todo(
        title: "Call mom?",
        dueDate: DateTime.parse("2021-02-13"),
        priority: 1
    ),
    Todo(
        title: "Have lunch with Sean",
        dueDate: DateTime.parse("2021-04-13"),
        priority: 2
    ),
    Todo(title: "Read Flutter documentation", priority: 3),
    Todo(title: "Watch the witcher TV Series on Netflix"),
    Todo(
        title: "Call mom?",
        dueDate: DateTime.parse("2021-02-13"),
        priority: 1
    ),
    Todo(title: "Have lunch with Sean", dueDate: DateTime.parse("2020-04-20")),
    Todo(
        title: "Read Flutter documentation",
        dueDate: DateTime.parse("2020-04-20"),
        isDone: true,
    ),
    Todo(title: "Watch the witcher", dueDate: DateTime.parse("2020-06-12")),
    Todo(title: "Call mom?", dueDate: DateTime.parse("2020-05-20")),
    Todo(title: "Have lunch with Sean", dueDate: DateTime.parse("2021-04-13")),
    Todo(title: "Read Flutter documentation"),
    Todo(title: "Watch the witcher TV Series on Netflix"),
    Todo(title: "Call mom?", dueDate: DateTime.parse("2021-02-13")),
  ];