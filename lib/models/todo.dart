import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

//flutter packages pub run build_runner build
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime dueDate;
  @HiveField(2)
  bool isDone;
  @HiveField(3)
  bool shouldRepeat;
  @HiveField(4)
  int priority;

  Todo({
      @required this.title,
      this.dueDate,
      this.isDone = false,
      this.shouldRepeat = false,
      this.priority = 0,
    });
}