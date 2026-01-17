import 'package:path_provider/path_provider.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'dart:io';

class TodoRepositoryFile implements TodoRepository {
  // 单例模式实现
  TodoRepositoryFile._internal();
  static final TodoRepositoryFile _instance = TodoRepositoryFile._internal();
  factory TodoRepositoryFile() => _instance;

  final List<Todo> _todos = [];

  get todos => _todos;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Future<List<Todo>> getAllTodos() {
    return Future.value(_todos);
  }

  @override
  Future<void> addTodo(Todo todo) {
    _todos.add(todo);
    print(_todos);
    return Future.value();
  }

  @override
  Future<void> updateTodo(Todo todo) {
    _todos[_todos.indexWhere((element) => element.id == todo.id)] = todo;
    return Future.value();
  }

  @override
  Future<void> deleteTodo(String id) {
    _todos.removeWhere((element) => element.id == id);
    return Future.value();
  }
}
