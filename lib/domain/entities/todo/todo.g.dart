// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
  id: json['id'] as String,
  title: json['title'] as String,
  completed: json['completed'] as bool?,
  important: json['important'] as bool?,
  remindAt: json['remindAt'] == null
      ? null
      : DateTime.parse(json['remindAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  repeat: $enumDecodeNullable(_$RepeatEnumMap, json['repeat']),
);

Map<String, dynamic> _$TodoToJson(_Todo instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'completed': instance.completed,
  'important': instance.important,
  'remindAt': instance.remindAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'repeat': _$RepeatEnumMap[instance.repeat],
};

const _$RepeatEnumMap = {
  Repeat.none: 'none',
  Repeat.daily: 'daily',
  Repeat.weekly: 'weekly',
  Repeat.monthly: 'monthly',
  Repeat.yearly: 'yearly',
};
