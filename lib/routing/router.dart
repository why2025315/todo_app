import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/data/repositories/todo/todo_repository_file.dart';

import 'package:todo_app/ui/about/widgets/about_screen.dart';
import 'package:todo_app/ui/detail/widgets/detail_screen.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todo_app/ui/todo/widgets/todo_screen.dart';
import 'package:todo_app/widgets/bottom_navigation.dart';

import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

// 创建单例的TodoRepository和TodoViewModel
final TodoRepositoryFile _todoRepository = TodoRepositoryFile();
final TodoViewModel _todoViewModel = TodoViewModel(
  todoRepository: _todoRepository,
);

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _homeNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(body: child, bottomNavigationBar: BottomNavigation());
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => TodoScreen(viewModel: _todoViewModel),
        ),
        GoRoute(
          path: Routes.detail,
          builder: (context, state) => DetailScreen(),
        ),
        GoRoute(path: Routes.about, builder: (context, state) => AboutScreen()),
      ],
    ),
  ],
);
