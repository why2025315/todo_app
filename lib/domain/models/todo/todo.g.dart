// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
  id: json['id'] as String?,
  title: json['title'] as String,
  completed: json['completed'] as bool?,
  important: json['important'] as bool?,
  remindAt: json['remindAt'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  repeat: $enumDecodeNullable(_$RepeatEnumMap, json['repeat']),
);

Map<String, dynamic> _$TodoToJson(_Todo instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'completed': instance.completed,
  'important': instance.important,
  'remindAt': instance.remindAt,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'repeat': _$RepeatEnumMap[instance.repeat],
};

const _$RepeatEnumMap = {
  Repeat.none: 'none',
  Repeat.daily: 'daily',
  Repeat.weekly: 'weekly',
  Repeat.monthly: 'monthly',
  Repeat.yearly: 'yearly',
};
