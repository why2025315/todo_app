import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todo_app/ui/todo/widgets/add_todo_modal.dart';
import 'package:todo_app/ui/todo/widgets/todo_list.dart';
import 'package:todo_app/widgets/bottom_navigation.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key, required this.viewModel});

  final TodoViewModel viewModel;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool isBatchDeleteMode = false;
  List<dynamic> selectedTodoIds = [];

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

  /// 切换指定ID的待办事项的选择状态
  ///
  /// [id] 要切换选择状态的待办事项ID
  ///
  /// 如果该ID已处于选中状态则取消选择，否则将其添加到选中列表
  void _toggleSelect(String id) {
    setState(() {
      if (selectedTodoIds.contains(id)) {
        selectedTodoIds.remove(id);
      } else {
        selectedTodoIds.add(id);
      }
    });
  }

  bool get isAllSelected {
    if (selectedTodoIds.isEmpty) {
      return false;
    }
    return selectedTodoIds.length == widget.viewModel.todos.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isBatchDeleteMode
            ? Text(
                selectedTodoIds.isNotEmpty
                    ? '已选择 ${selectedTodoIds.length} 项'
                    : '未选择',
              )
            : const Text('待办事项'),
        leading: isBatchDeleteMode == true
            ? CloseButton(
                onPressed: () {
                  setState(() {
                    isBatchDeleteMode = false;
                  });
                },
              )
            : null,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'batch_delete', child: Text('批量删除')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'batch_delete':
                  setState(() {
                    selectedTodoIds = widget.viewModel.todos
                        .where((todo) => todo.completed == true)
                        .map((todo) => todo.id)
                        .toList();
                    isBatchDeleteMode = true;
                  });
                  break;
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          TodoList(
            viewModel: widget.viewModel,
            isBatchDeleteMode: isBatchDeleteMode,
            toggleSelect: _toggleSelect,
            selectedTodoIds: selectedTodoIds,
          ),
          if (isBatchDeleteMode)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              if (isAllSelected) {
                                selectedTodoIds.clear();
                              } else {
                                selectedTodoIds = widget.viewModel.todos
                                    .map((todo) => todo.id)
                                    .toList();
                              }
                            });
                          },
                          icon: const Icon(Icons.checklist),
                          label: Text(isAllSelected ? '取消全选' : '全选'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: selectedTodoIds.isNotEmpty
                              ? () {
                                  if (selectedTodoIds.isNotEmpty) {
                                    widget.viewModel.batchDeleteTodos(
                                      selectedTodoIds,
                                    );
                                    setState(() {
                                      selectedTodoIds.clear();
                                      isBatchDeleteMode = false;
                                    });
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.delete),
                          label: const Text('删除'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isBatchDeleteMode ? null : BottomNavigation(),
      floatingActionButton: isBatchDeleteMode == false
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  builder: (context) =>
                      AddTodoModal(viewModel: widget.viewModel),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
