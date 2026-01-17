import 'package:flutter/material.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/utils/command.dart';
import 'package:todo_app/utils/result.dart';
import 'package:flutter/cupertino.dart';

class TodoViewModel extends ChangeNotifier {
  TodoViewModel({required this.todoRepository}) {
    load = Command0(_load)..execute();
  }

  late Command0 load;
  final TodoRepository todoRepository;
  List<Todo> _todos = [];

  get todos => _todos;

  Future<Result<List<Todo>>> _load() async {
    try {
      final todos = await todoRepository.getAllTodos();
      _todos = todos;
      return Result.ok(_todos);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await todoRepository.addTodo(todo);
      // 直接从仓库获取最新数据，更新本地状态
      _todos = await todoRepository.getAllTodos();
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await todoRepository.deleteTodo(id);
      // 直接从仓库获取最新数据，更新本地状态
      _todos = await todoRepository.getAllTodos();
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await todoRepository.updateTodo(todo);
      // 直接从仓库获取最新数据，更新本地状态
      _todos = await todoRepository.getAllTodos();
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
