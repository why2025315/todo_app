import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key, required this.viewModel});

  final TodoViewModel viewModel;
  void doNothing(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    if (viewModel.todos.isEmpty) {
      return const Center(child: Text('没有待办事项'));
    }
    return ListView.builder(
      itemCount: viewModel.todos.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: Key(viewModel.todos[index].id),

          endActionPane: ActionPane(
            motion: ScrollMotion(),
            dismissible: DismissiblePane(
              confirmDismiss: () async {
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
              onDismissed: () {
                viewModel.deleteTodo(viewModel.todos[index].id);
              },
            ),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 2,
                onPressed: doNothing,
                backgroundColor: Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.archive,
                label: '归档',
              ),
              SlidableAction(
                onPressed: (context) => _onDismissed(context, index),
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: '删除',
              ),
            ],
          ),
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
            subtitle:
                (viewModel.todos[index].important == true ||
                    viewModel.todos[index].remindAt != null)
                ? Row(
                    children: [
                      if (viewModel.todos[index].important == true)
                        Icon(Icons.flag, color: Colors.red),
                      if (viewModel.todos[index].remindAt != null)
                        Text(
                          '提醒时间: ${viewModel.todos[index].remindAt!.toLocal()}',
                        ),
                    ],
                  )
                : null,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }

  void _onDismissed(BuildContext context, int index) async {
    final confirm = await showDialog(
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
    if (confirm == true) {
      viewModel.deleteTodo(viewModel.todos[index].id);
    }
  }
}
