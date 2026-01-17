import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key, required this.viewModel});

  final TodoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.todos.isEmpty) {
      return const Center(child: Text('没有待办事项'));
    }
    return ListView.builder(
      itemCount: viewModel.todos.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(viewModel.todos[index].id),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('确认删除'),
                content: const Text('确定要删除这个待办事项吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('删除'),
                  ),
                ],
              ),
            );
          },
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.yellowAccent),
                  onPressed: () {
                    // 处理编辑待办事项的逻辑
                  },
                ),
                const Icon(Icons.delete, color: Colors.red),
              ],
            ),
          ),
          onDismissed: (direction) {
            viewModel.deleteTodo(viewModel.todos[index].id);
          },
          child: CheckboxListTile(
            title: Text(
              viewModel.todos[index].title,
              style: viewModel.todos[index].completed == true
                  ? TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    )
                  : null,
            ),
            value: viewModel.todos[index].completed ?? false,
            onChanged: (value) {
              viewModel.updateTodo(
                viewModel.todos[index].copyWith(completed: value),
              );
            },
            subtitle: Row(
              children: [
                if (viewModel.todos[index].important == true)
                  Icon(Icons.flag, color: Colors.red),
                if (viewModel.todos[index].remindAt != null)
                  Text('提醒时间: ${viewModel.todos[index].remindAt!.toLocal()}'),
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }
}
