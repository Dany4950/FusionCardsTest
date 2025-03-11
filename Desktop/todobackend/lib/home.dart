import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String subtitle;

  Todo({required this.title, required this.subtitle});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Todo> _todos = [];

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text("Todo JFS"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: _todos.isEmpty
            ? const Center(
                child: Text("No todos yet. Add some!"),
              )
            : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      title: Text(_todos[index].title),
                      subtitle: Text(_todos[index].subtitle),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _todos.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateTodoDialog(
              onSave: (todo) => _addTodo(todo),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateTodoDialog extends StatelessWidget {
  final Function(Todo) onSave;

  const CreateTodoDialog({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();

    return AlertDialog(
      title: const Text("Create Todo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
            ),
          ),
          TextField(
            controller: subtitleController,
            decoration: const InputDecoration(
              labelText: "Subtitle",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Validate input
            if (titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Title cannot be empty")),
              );
              return;
            }

            // Create todo and pass it back
            final newTodo = Todo(
              title: titleController.text,
              subtitle: subtitleController.text,
            );

            onSave(newTodo);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
