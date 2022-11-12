import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:part2/models/todo_list.dart';
import 'package:part2/screens/listScreen.dart';
import 'package:part2/screens/updateScreen.dart';
import 'package:part2/services/todo_list_repository.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Todo todo;
  const DetailScreen({super.key, required this.todo});

  @override
  State<DetailScreen> createState() => _DetailScreenState(todo: todo);
}

class _DetailScreenState extends State<DetailScreen> {
  Todo todo;

  _DetailScreenState({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail d'un todo"),
        actions: [
          OutlinedButton(
            onPressed: (() {
              String result = onDeleteButtonClicked(context);
              final snackBar = SnackBar(
                content: Text(result), 
                action: SnackBarAction(
                  label: "", 
                  onPressed: (() {})
                )
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: null,
                ),
                Text(todo.name, style: const TextStyle(fontSize: 20.0)),
                const SizedBox(width: 70)
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  width: 350,
                  child: Text(todo.desc, style: const TextStyle(fontSize: 18.0))
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateScreen(todo: widget.todo))).then((_) => refreshTodo(context)),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            )
          ],
        ),
      )
    );
  }

  String onDeleteButtonClicked(BuildContext context) {
    try {
      Future future = Provider.of<TodoList>(context, listen: false).deleteTodo(todo.id);
      future.whenComplete(() {
        Navigator.pop(context, "deleteDone");
      });
      return "Le todo ${widget.todo.name} a bien été effacé!";
    } catch (e) {
      return "Une erreur est survenu...";
    }
  }
  
  refreshTodo(BuildContext context) {
    Todo? todoById = Provider.of<TodoList>(context, listen: false).getById(todo.id);
    if(todoById != null) {
      setState(() {
        todo = todoById;
      });
    }
  }
}
