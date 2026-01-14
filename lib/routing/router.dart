import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:todo_app/ui/about/widgets/about_screen.dart';
import 'package:todo_app/ui/detail/widgets/detail_screen.dart';
import 'package:todo_app/ui/home/widgets/home_screen.dart';
import 'package:todo_app/widgets/bottom_navigation.dart';

import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

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
        GoRoute(path: Routes.home, builder: (context, state) => HomeScreen()),
        GoRoute(
          path: Routes.detail,
          builder: (context, state) => DetailScreen(),
        ),
        GoRoute(path: Routes.about, builder: (context, state) => AboutScreen()),
      ],
    ),
  ],
);
