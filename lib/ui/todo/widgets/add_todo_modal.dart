import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/domain/entities/todo/todo.dart';
import 'package:todo_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todo_app/ui/todo/widgets/available_maps.dart';

class AddTodoModal extends StatefulWidget {
  const AddTodoModal({super.key, required this.viewModel});

  final TodoViewModel viewModel;

  @override
  State<AddTodoModal> createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  final TextEditingController _todoController = TextEditingController();
  bool? important;
  DateTime? remindAt;

  @override
  dispose() {
    _todoController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 这里可以添加表单字段
          Builder(
            builder: (context) {
              return TextField(
                controller: _todoController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '待办事项',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Color(0xFFF2F2F2),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              );
            },
          ),
          // 显示所选的日期和时间
          if (remindAt != null) ...[
            const SizedBox(height: 10),
            Text(
              '提醒时间: ${remindAt!.year}-${remindAt!.month.toString().padLeft(2, '0')}-${remindAt!.day.toString().padLeft(2, '0')} ${remindAt!.hour.toString().padLeft(2, '0')}:${remindAt!.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: remindAt ?? DateTime.now(),
                            use24hFormat: false,
                            dateOrder: DatePickerDateOrder.ymd,
                            // This is called when the user changes the dateTime.
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() => remindAt = newDateTime);
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.alarm),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDialog(AvailableMaps());
                      },
                      icon: Icon(Icons.location_on),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          important = !(important ?? false);
                        });
                      },
                      icon: Icon(Icons.flag),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      color: important ?? false ? Colors.red : null,
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  // 处理添加待办事项的逻辑
                  handleAddTodo();
                },
                child: const Text('添加'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleAddTodo() {
    if (_todoController.text.isNotEmpty) {
      widget.viewModel.addTodo(
        Todo(
          title: _todoController.text,
          important: important,
          remindAt: remindAt,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
