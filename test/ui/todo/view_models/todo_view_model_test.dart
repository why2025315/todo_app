import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';

@GenerateMocks([TodoRepository])
import 'todo_view_model_test.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late TodoViewModel todoViewModel;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });

  group('_load method tests', () {
    test('should return Result.ok with todos list when repository returns data successfully', () async {
      // Arrange
      final expectedTodos = [
        const Todo(id: '1', title: 'Test Todo 1', completed: false),
        const Todo(id: '2', title: 'Test Todo 2', completed: true),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for async operation

      // Assert
      expect(todoViewModel.todos.length, 2);
      expect(todoViewModel.todos, equals(expectedTodos));
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should return Result.ok with empty list when repository returns empty data', () async {
      // Arrange
      final expectedTodos = <Todo>[];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(todoViewModel.todos.length, 0);
      expect(todoViewModel.todos, isEmpty);
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should handle single todo item', () async {
      // Arrange
      final expectedTodos = [
        const Todo(id: '1', title: 'Single Todo', completed: false),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(todoViewModel.todos.length, 1);
      expect(todoViewModel.todos.first.title, 'Single Todo');
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should return Result.error when repository throws exception', () async {
      // Arrange
      const errorMessage = 'Network error occurred';
      when(mockTodoRepository.getAllTodos()).thenThrow(Exception(errorMessage));

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should update _todos internal state after successful load', () async {
      // Arrange
      final firstTodos = [
        const Todo(id: '1', title: 'First Todo', completed: false),
      ];
      final secondTodos = [
        const Todo(id: '1', title: 'First Todo', completed: false),
        const Todo(id: '2', title: 'Second Todo', completed: true),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => firstTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - initial state
      expect(todoViewModel.todos.length, 1);

      // Arrange - update mock to return different data
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => secondTodos);

      // Act - call load again
      await todoViewModel.load.execute();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - state updated
      expect(todoViewModel.todos.length, 2);
      verify(mockTodoRepository.getAllTodos()).called(2);
    });

    test('should notify listeners after load completes', () async {
      // Arrange
      final expectedTodos = [
        const Todo(id: '1', title: 'Test Todo', completed: false),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);
      var listenerCalled = false;

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      todoViewModel.addListener(() {
        listenerCalled = true;
      });
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(listenerCalled, true);
    });

    test('should handle generic exception types', () async {
      // Arrange
      when(mockTodoRepository.getAllTodos()).thenThrow(const FormatException('Invalid data format'));

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should handle todos with all optional fields populated', () async {
      // Arrange
      final expectedTodos = [
        const Todo(
          id: '1',
          title: 'Complete Todo',
          completed: true,
          important: true,
          remindAt: '2024-01-17T10:00:00Z',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-17T09:00:00Z',
          repeat: Repeat.daily,
        ),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(todoViewModel.todos.length, 1);
      expect(todoViewModel.todos.first.completed, true);
      expect(todoViewModel.todos.first.important, true);
      expect(todoViewModel.todos.first.repeat, Repeat.daily);
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should handle todos with only required fields', () async {
      // Arrange
      final expectedTodos = [
        const Todo(title: 'Minimal Todo'),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(todoViewModel.todos.length, 1);
      expect(todoViewModel.todos.first.title, 'Minimal Todo');
      expect(todoViewModel.todos.first.completed, null);
      expect(todoViewModel.todos.first.important, null);
      verify(mockTodoRepository.getAllTodos()).called(1);
    });
  });

  group('TodoViewModel integration tests', () {
    test('should initialize and auto-load todos on creation', () async {
      // Arrange
      final expectedTodos = [
        const Todo(id: '1', title: 'Auto-loaded Todo', completed: false),
      ];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => expectedTodos);

      // Act
      todoViewModel = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(todoViewModel.todos, isNotEmpty);
      verify(mockTodoRepository.getAllTodos()).called(1);
    });

    test('should maintain separate TodoViewModel instances', () async {
      // Arrange
      final todos1 = [const Todo(id: '1', title: 'Todo 1', completed: false)];
      final todos2 = [const Todo(id: '2', title: 'Todo 2', completed: true)];
      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => todos1);

      // Act
      final viewModel1 = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      when(mockTodoRepository.getAllTodos()).thenAnswer((_) async => todos2);
      final viewModel2 = TodoViewModel(todoRepository: mockTodoRepository);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(viewModel1.todos.first.title, 'Todo 1');
      expect(viewModel2.todos.first.title, 'Todo 2');
    });
  });
}
