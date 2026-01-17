import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todo_app/ui/todo/widgets/add_todo_modal.dart';
import 'package:todo_app/ui/todo/widgets/todo_list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key, required this.viewModel});

  final TodoViewModel viewModel;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    // 监听viewModel的变化
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    // 移除监听
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  //  @override
  // void didUpdateWidget(covariant LoginScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   oldWidget.viewModel.login.removeListener(_onResult);
  //   widget.viewModel.login.addListener(_onResult);
  // }

  void _onViewModelChanged() {
    // 当viewModel数据变化时，重建UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('待办事项')),
      body: TodoList(viewModel: widget.viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (context) => AddTodoModal(viewModel: widget.viewModel),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
