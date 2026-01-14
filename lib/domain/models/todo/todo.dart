import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

enum Repeat { none, daily, weekly, monthly, yearly }

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    String? id,
    required String title,
    bool? completed,
    bool? important,
    String? remindAt,
    String? createdAt,
    String? updatedAt,
    Repeat? repeat,
  }) = _Todo;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}
