import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:part2/screens/detailScreen.dart';
import 'package:provider/provider.dart';
import '../models/todo_list.dart';

class TodosListElement extends StatefulWidget {
  final Todo todo;
  final Function function;

  const TodosListElement({Key? key, required this.todo, required this.function}) : super(key: key);

  @override
  State<TodosListElement> createState() => _TodosListElement(todo: todo);
}

class _TodosListElement extends State<TodosListElement> {
  bool isChecked = false;
  Todo todo;

  _TodosListElement({required this.todo});

  @override
  void initState() {
    setState(() {
      isChecked = widget.todo.isCompleted;
    });
    //log(isChecked.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (newValue) {
                _changeStatus(newValue!);
              },
            ),
            Text(todo.name),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen(todo: todo))).then((_) => widget.function()),
              child: const Icon(
                Icons.info,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ]
    );
  }
  
  void _changeStatus(bool newValue) {
    Provider.of<TodoList>(context, listen: false).changeTodoStatus(todo.id, newValue);
    Provider.of<TodoList>(context, listen: false).saveCurrentTodosToRepository();
    todo = Todo(id: todo.id, name: todo.name, desc: todo.desc, isCompleted: newValue);
    setState(() {
      isChecked = newValue;
    });
  }
}