import 'package:flutter/material.dart';
import 'package:todo_app/data/repositories/todo/todo_responsitory_hive.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';
import 'package:todo_app/utils/command.dart';
import 'package:todo_app/utils/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

final log = Logger('TodoViewModel');

class TodoViewModel extends ChangeNotifier {
  TodoViewModel({required this.todoRepository}) {
    load = Command0(_load)..execute();
  }

  late Command0 load;
  final TodoResponsitoryHive todoRepository;
  List<Todo> _todos = [];

  get todos => _todos;

  Future<Result<List<Todo>>> _load() async {
    try {
      _todos = await todoRepository.loadAll();
      return Result.ok(_todos);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      _todos.add(todo);
      // 直接从仓库获取最新数据，更新本地状态
      todoRepository.add(todo);
      log.fine('Add Todo: $todo $_todos');
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      _todos.removeWhere((ele) => ele.id == id);
      // 直接从仓库获取最新数据，更新本地状态
      todoRepository.delete(id);
      log.fine('Delete Todo: $id');
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final index = _todos.indexWhere((ele) => ele.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
      }
      todoRepository.update(todo);
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> batchDeleteTodos(List<dynamic> ids) async {
    try {
      // 从本地状态中移除已完成的待办事项
      _todos.removeWhere((ele) => ids.contains(ele.id));
      // 调用仓库的批量删除方法
      await todoRepository.batchDeleteCompleted(ids as List<String>);
      log.fine('Batch Delete Completed Todos');
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
