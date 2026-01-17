import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/config/providers.dart';
import 'package:todo_app/config/theme.dart';
import 'package:todo_app/routing/router.dart';

void main() {
  runApp(MultiProvider(providers: providers, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router, theme: themeDataConfig);
  }
}
