import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/routing/routes.dart' show Routes;

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: BottomTab.home.title,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: BottomTab.about.title,
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        context.go(BottomTab.values[index].route);
      },
    );
  }
}

enum BottomTab {
  home("首页", Routes.home),
  about("关于", Routes.about);

  final String title;
  final String route;
  const BottomTab(this.title, this.route);
}
