import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

enum Repeat { none, daily, weekly, monthly, yearly }

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    bool? completed,
    bool? important,
    DateTime? remindAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Repeat? repeat,
  }) = _Todo;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}
