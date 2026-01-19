import 'package:hive/hive.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';

@HiveType(typeId: 0)
class TodoEntity extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool? completed;

  @HiveField(3)
  bool? important;

  @HiveField(4)
  DateTime? remindAt;

  @HiveField(5)
  DateTime? createdAt;

  @HiveField(6)
  DateTime? updatedAt;

  @HiveField(7)
  Repeat? repeat;

  TodoEntity({
    required this.id,
    required this.title,
    required this.completed,
    this.important = false,
    this.remindAt,
    this.createdAt,
    this.updatedAt,
    this.repeat,
  });

  // 转换为业务模型
  Todo toTodo() {
    return Todo(
      id: id,
      title: title,
      completed: completed,
      important: important,
      remindAt: remindAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      repeat: repeat,
    );
  }

  // 从业务模型转换
  factory TodoEntity.fromTodo(Todo todo) {
    return TodoEntity(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      important: todo.important,
      remindAt: todo.remindAt,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
      repeat: todo.repeat,
    );
  }
}
