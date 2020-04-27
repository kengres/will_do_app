import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// flutter packages pub run build_runner build
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime dueDate;

  @HiveField(2)
  String dueTime;

  @HiveField(3)
  bool isDone;

  @HiveField(4)
  bool shouldRepeat;

  @HiveField(5)
  int priority;

  Todo({
    @required this.title,
    this.dueDate,
    this.dueTime,
    this.isDone = false,
    this.shouldRepeat = false,
    this.priority = 0,
  });
}