import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_todo/controllers/todocontroller.dart';
import 'package:getx_todo/screens/todoscreens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.put(TodoController());
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(TodoScreen());
        },
      ),
      body: Container(
        child: Obx(
          () => ListView.separated(
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              onDismissed: (_) {
                var removed = todoController.todos[index];
                todoController.todos.removeAt(index);
                Get.snackbar(
                  'Task removed',
                  'The task "${removed.text}" was successfully removed.',
                  mainButton: TextButton(
                    child: Text(
                      'Undo',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (removed == null) {
                        return;
                      }
                      todoController.todos.insert(index, removed);
                      removed = null;
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  todoController.todos[index].text,
                  style: (todoController.todos[index].done)
                      ? TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough)
                      : TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onTap: () {
                  Get.to(TodoScreen(
                    index: index,
                  ));
                },
                leading: Checkbox(
                    value: todoController.todos[index].done,
                    onChanged: (v) {
                      var changed = todoController.todos[index];
                      changed.done = v;
                      todoController.todos[index] = changed;
                    }),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            separatorBuilder: (_, index) => Divider(),
            itemCount: todoController.todos.length,
          ),
        ),
      ),
    );
  }
}
