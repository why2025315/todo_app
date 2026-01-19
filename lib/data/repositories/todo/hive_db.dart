import 'package:hive/hive.dart';

class TodoApp {
  List todoList = [];

  final myBox = Hive.box('todos');

  void loadData() {
    todoList = myBox.get('TODOLIST');
  }

  void updateData() {
    myBox.put('TODOLIST', todoList);
  }
}
