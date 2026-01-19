import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';
import 'package:todo_app/domain/entities/todo_entity/todo_entity.dart';
import 'package:todo_app/domain/entities/todo_entity/todo_entity.g.dart';

class TodoResponsitoryHive {
  static const String _boxName = 'todos';

  // 单例模式实现
  TodoResponsitoryHive._internal();
  static final TodoResponsitoryHive _instance =
      TodoResponsitoryHive._internal();
  factory TodoResponsitoryHive() => _instance;

  // Hive盒子实例 - 类型化为TodoEntity
  Box<TodoEntity>? _todosBox;

  // 是否已初始化
  bool _isInitialized = false;
  final _log = Logger('TodoRepositoryFile');

  /// 初始化Hive
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // 注册Hive适配器
      Hive.registerAdapter(TodoEntityAdapter());

      // 打开类型化的盒子
      _todosBox = await Hive.openBox<TodoEntity>(_boxName);

      _isInitialized = true;
    } catch (e) {
      _log.severe('Hive初始化失败: $e');
      rethrow;
    }
  }

  Future<Box<TodoEntity>> _openBox() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _todosBox!;
  }

  // 添加待办事项
  Future<void> add(Todo todo) async {
    final box = await _openBox();
    final todoEntity = TodoEntity.fromTodo(todo);
    await box.put(todo.id, todoEntity);
  }

  // 从数据库加载所有待办事项
  Future<List<Todo>> loadAll() async {
    final box = await _openBox();
    return box.values.map((entity) => entity.toTodo()).toList();
  }

  // 删除
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  // 更新
  Future<void> update(Todo todo) async {
    final box = await _openBox();
    final todoEntity = TodoEntity.fromTodo(todo);
    await box.put(todo.id, todoEntity);
  }
}
