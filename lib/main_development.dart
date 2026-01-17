import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/config/providers.dart';

import 'main.dart';

void main() {
  Logger.root.level = Level.ALL;

  runApp(MultiProvider(providers: providers, child: MyApp()));
}
