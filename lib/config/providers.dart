import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_app/data/repositories/todo/todo_repository_file.dart';

List<SingleChildWidget> get providers => [
  Provider(create: (_) => TodoRepositoryFile()),
];
