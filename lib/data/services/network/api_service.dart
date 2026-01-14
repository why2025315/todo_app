import 'package:todo_app/domain/models/todo/todo.dart';
import 'package:todo_app/utils/result.dart';

import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  // 获取所有待办事项
  Future<Result<List<Todo>>> getTodos() async {
    try {
      final response = await _dioClient.dio.get('/todos');
      final todos = (response.data as List)
          .map((json) => Todo.fromJson(json))
          .toList();
      return Result.ok(todos);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  // 获取单个待办事项
  Future<Result<Todo>> getTodoById(int id) async {
    try {
      final response = await _dioClient.dio.get('/todos/$id');
      final todo = Todo.fromJson(response.data);
      return Result.ok(todo);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  // 创建待办事项
  Future<Result<Todo>> createTodo(Todo todo) async {
    try {
      final response = await _dioClient.dio.post('/todos', data: todo.toJson());
      final createdTodo = Todo.fromJson(response.data);
      return Result.ok(createdTodo);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  // 更新待办事项
  Future<Result<Todo>> updateTodo(int id, Todo todo) async {
    try {
      final response = await _dioClient.dio.put(
        '/todos/$id',
        data: todo.toJson(),
      );
      final updatedTodo = Todo.fromJson(response.data);
      return Result.ok(updatedTodo);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  // 删除待办事项
  Future<Result<void>> deleteTodo(int id) async {
    try {
      await _dioClient.dio.delete('/todos/$id');
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
