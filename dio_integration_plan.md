# Dio引入本项目的最佳实践方案

## 项目现状分析

1. **已引入dio依赖**：在`pubspec.yaml`第39行已添加`dio: ^5.9.0`
2. **采用Clean Architecture**：
   - `data/`：数据处理层
   - `domain/`：业务逻辑层
   - `ui/`：界面展示层
   - `config/`：配置层
   - `routing/`：路由管理
   - `utils/`：工具类
   - `widgets/`：通用组件

## 最佳实践方案

### 1. 创建Dio配置与单例

在`data/services/`目录下创建网络配置：

```dart
// lib/data/services/network/dio_config.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConfig {
  static const String baseUrl = 'https://api.example.com'; // 替换为实际API地址
  static const int timeout = 15000; // 15秒超时
}

// lib/data/services/network/dio_client.dart
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: DioConfig.baseUrl,
      connectTimeout: Duration(milliseconds: DioConfig.timeout),
      receiveTimeout: Duration(milliseconds: DioConfig.timeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加拦截器
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // 请求拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 可以在这里添加认证令牌、日志等
        if (kDebugMode) {
          print('Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          if (options.data != null) {
            print('Data: ${options.data}');
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 可以在这里统一处理响应数据
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.statusMessage}');
          print('Data: ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // 可以在这里统一处理错误
        if (kDebugMode) {
          print('Error: ${e.message}');
          print('Error Type: ${e.type}');
          if (e.response != null) {
            print('Error Response: ${e.response?.data}');
          }
        }
        return handler.next(e);
      },
    ));
  }
}
```

### 2. 创建API服务类

在`data/services/`目录下创建API服务：

```dart
// lib/data/services/network/api_service.dart
import 'package:dio/dio.dart';
import '../models/todo/todo.dart';
import '../../utils/result.dart';
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
      return Result.success(todos);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // 获取单个待办事项
  Future<Result<Todo>> getTodoById(int id) async {
    try {
      final response = await _dioClient.dio.get('/todos/$id');
      final todo = Todo.fromJson(response.data);
      return Result.success(todo);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // 创建待办事项
  Future<Result<Todo>> createTodo(Todo todo) async {
    try {
      final response = await _dioClient.dio.post('/todos', data: todo.toJson());
      final createdTodo = Todo.fromJson(response.data);
      return Result.success(createdTodo);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // 更新待办事项
  Future<Result<Todo>> updateTodo(int id, Todo todo) async {
    try {
      final response = await _dioClient.dio.put('/todos/$id', data: todo.toJson());
      final updatedTodo = Todo.fromJson(response.data);
      return Result.success(updatedTodo);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // 删除待办事项
  Future<Result<void>> deleteTodo(int id) async {
    try {
      await _dioClient.dio.delete('/todos/$id');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
```

### 3. 创建数据仓库层

在`data/`目录下创建数据仓库，统一管理本地和远程数据：

```dart
// lib/data/repositories/todo_repository.dart
import '../services/network/api_service.dart';
import '../services/local/local_data_service.dart';
import '../../domain/models/todo/todo.dart';
import '../../utils/result.dart';

class TodoRepository {
  final ApiService _apiService;
  final LocalDataService _localDataService;

  TodoRepository({
    required ApiService apiService,
    required LocalDataService localDataService,
  })  : _apiService = apiService,
        _localDataService = localDataService;

  // 获取待办事项列表（优先网络，失败则使用本地缓存）
  Future<Result<List<Todo>>> getTodos() async {
    // 尝试从网络获取
    final networkResult = await _apiService.getTodos();
    if (networkResult.isSuccess && networkResult.data != null) {
      // 保存到本地缓存
      await _localDataService.saveTodos(networkResult.data!);
      return networkResult;
    }

    // 网络失败，尝试从本地获取
    final localResult = await _localDataService.getTodos();
    if (localResult.isSuccess && localResult.data != null) {
      return localResult;
    }

    // 均失败
    return Result.failure('Failed to get todos from both network and local storage');
  }

  // 其他CRUD方法类似...
}
```

### 4. 错误处理机制

扩展现有的`utils/result.dart`以支持更详细的错误信息：

```dart
// lib/utils/api_error.dart
enum ApiErrorType {
  network,
  server,
  unauthorized,
  notFound,
  validation,
  other,
}

class ApiError {
  final ApiErrorType type;
  final String message;
  final int? statusCode;

  ApiError({
    required this.type,
    required this.message,
    this.statusCode,
  });

  factory ApiError.fromDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiError(
        type: ApiErrorType.network,
        message: 'Network error occurred. Please check your connection.',
      );
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      switch (statusCode) {
        case 401:
          return ApiError(
            type: ApiErrorType.unauthorized,
            message: 'Unauthorized access. Please login again.',
            statusCode: statusCode,
          );
        case 404:
          return ApiError(
            type: ApiErrorType.notFound,
            message: 'Resource not found.',
            statusCode: statusCode,
          );
        case 422:
          return ApiError(
            type: ApiErrorType.validation,
            message: 'Validation error occurred.',
            statusCode: statusCode,
          );
        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
          return ApiError(
            type: ApiErrorType.server,
            message: 'Server error occurred. Please try again later.',
            statusCode: statusCode,
          );
        default:
          return ApiError(
            type: ApiErrorType.other,
            message: e.response?.data['message'] ?? 'An unexpected error occurred.',
            statusCode: statusCode,
          );
      }
    }

    return ApiError(
      type: ApiErrorType.other,
      message: e.message ?? 'An unexpected error occurred.',
    );
  }
}
```

### 5. 与现有架构集成

在`main.dart`中注册依赖：

```dart
// lib/main.dart (部分代码)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routing/router.dart';
import 'config/theme.dart';
import 'data/services/network/api_service.dart';
import 'data/services/local/local_data_service.dart';
import 'data/repositories/todo_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建依赖实例
    final apiService = ApiService();
    final localDataService = LocalDataService();
    final todoRepository = TodoRepository(
      apiService: apiService,
      localDataService: localDataService,
    );

    return MaterialApp.router(
      title: 'Todo App',
      theme: appTheme,
      routerConfig: createRouter(todoRepository), // 将repository传递给路由
    );
  }
}
```

### 6. 在UI层使用

在屏幕组件中使用：

```dart
// lib/ui/home/widgets/home_screen.dart (部分代码)
import 'package:flutter/material.dart';
import 'package:todo_app/domain/models/todo/todo.dart';
import 'package:todo_app/data/repositories/todo_repository.dart';
import 'package:todo_app/utils/result.dart';

class HomeScreen extends StatefulWidget {
  final TodoRepository todoRepository;

  const HomeScreen({super.key, required this.todoRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await widget.todoRepository.getTodos();
    setState(() {
      _isLoading = false;
      if (result.isSuccess && result.data != null) {
        _todos = result.data!;
      } else {
        _errorMessage = result.error;
      }
    });
  }

  // 其他UI代码...
}
```

## 方案优势

1. **遵循Clean Architecture**：保持各层分离，提高可维护性
2. **集中配置**：Dio单例集中管理配置和拦截器
3. **可测试性**：依赖注入便于单元测试
4. **错误处理**：统一的错误处理机制，提供友好的用户反馈
5. **缓存策略**：结合本地存储实现离线支持
6. **扩展性**：便于添加新的API端点和功能

## 实施步骤建议

1. 创建Dio配置和单例
2. 实现API服务类
3. 创建数据仓库层
4. 扩展错误处理机制
5. 与现有架构集成
6. 更新UI层使用新的API服务
7. 添加单元测试

此方案符合项目现有的Clean Architecture模式，能够无缝集成dio库，同时提供良好的可维护性和扩展性。
