import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/config/providers.dart';
import 'package:todo_app/config/theme.dart';
import 'package:todo_app/routing/router.dart';
import 'package:logging/logging.dart';

// 异步初始化函数

void main() async {
  // 确保Flutter绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;

  // Logger.root.onRecord.listen((record) {
  //   print('${record.level.name}: ${record.time}: ${record.message}');
  // });
  // 启动应用
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
