import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/store/store.dart';

class TodoData extends ChangeNotifier {
  List<Todo> _allTodos = [];
  Todo _activeTodo;

  void getAllTodos () {
    var box = Hive.box(todoBoxName);
    print("=====================");
    print("getting todos ${box.values.length}");
     //print(box.values.toList()[0].name);
    _allTodos = box.values.toList().cast<Todo>();
    // notifyListeners();
  }

  Todo getTodo(index) {
    return _allTodos[index];
  }

  void addTodoItem(Todo newTodo) async {
    print("call add contact");
    var box = Hive.box(todoBoxName);
    await box.add(newTodo);
    _allTodos = box.values.toList().cast<Todo>();
    notifyListeners();
  }

  void deleteTodo(int key) async {
    var box = Hive.box(todoBoxName);
    await box.delete(key);
    _allTodos = box.values.toList().cast<Todo>();
    print("Deleted contact at key $key");
    notifyListeners();
  }

  void editContact(Todo contact, int contactKey) async {
    var box = Hive.box(todoBoxName);
    await box.put(contactKey, contact);
    _allTodos = box.values.toList();
    print("Edited contact at key $contactKey");
    notifyListeners();
  }

  void toggleDone(int key) async {
    var box = Hive.box(todoBoxName);
    Todo todo = box.get(key);
    todo.isDone = !todo.isDone;
    await box.put(key, todo);
    _allTodos = box.values.toList().cast<Todo>();
    notifyListeners();
  }

  void setActiveContact(int contactKey) async {
    var box = Hive.box(todoBoxName);
    _activeTodo = box.get(contactKey);
    print("Setting active contact, key: ${_activeTodo.title}");
    notifyListeners();
  }

  Todo getActiveTodo() {
    print("getting active contact: ${_activeTodo?.title}");
    return _activeTodo;
  }

  int get todoCount {
    return _allTodos.length;
  }

  void clearAll () {
    var box = Hive.box(todoBoxName);
    box.clear();
    _allTodos = box.values.toList().cast<Todo>();
  }
}
