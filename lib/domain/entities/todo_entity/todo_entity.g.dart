// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:hive/hive.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';

import 'todo_entity.dart';

// 手动编写的Hive适配器代码，用于替代自动生成
class TodoEntityAdapter extends TypeAdapter<TodoEntity> {
  @override
  final int typeId = 0;

  @override
  TodoEntity read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final completed = reader.read() as bool?;
    final important = reader.read() as bool?;
    final remindAt = reader.read() as DateTime?;
    final createdAt = reader.read() as DateTime?;
    final updatedAt = reader.read() as DateTime?;
    final repeatIndex = reader.read() as int?;
    Repeat? repeat;

    if (repeatIndex != null) {
      repeat = Repeat.values[repeatIndex];
    }

    return TodoEntity(
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

  @override
  void write(BinaryWriter writer, TodoEntity obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.write(obj.completed);
    writer.write(obj.important);
    writer.write(obj.remindAt);
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
    writer.write(obj.repeat?.index);
  }
}
