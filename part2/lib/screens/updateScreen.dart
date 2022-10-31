import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:part2/models/todo_list.dart';
import 'package:part2/screens/detailScreen.dart';
import 'package:part2/services/todo_list_repository.dart';
import 'package:part2/validators/text_field_validator.dart';
import 'package:provider/provider.dart';

class UpdateScreen extends StatefulWidget {
  Todo todo;

  UpdateScreen({super.key, required this.todo});

  @override
  State<UpdateScreen> createState() => _UpdateScreen(todo: todo);
}

class _UpdateScreen extends State<UpdateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String nameError = "";
  String descError = "";

  Todo todo;
  bool isCompleted;

  _UpdateScreen({required this.todo}): isCompleted = todo.isCompleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mettre à jour un todo")),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text("Titre:", style: TextStyle(fontSize: 20.0)),
                const SizedBox(width: 70),
                Container(
                  width: 250,
                  height: 40,
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    controller: _nameController..text = todo.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder()
                    ),
                  )
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 300,
                  height: 14,
                  alignment: Alignment.topLeft,
                  child: Text(nameError, style: TextStyle(color: Colors.red.shade700, fontSize: 11))
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text("Descritption: ", style: TextStyle(fontSize: 20.0)),
                Container(
                  width: 250,
                  height: 40,
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    controller: _descController..text = todo.desc,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder()
                    )
                  )
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 300,
                  height: 14,
                  alignment: Alignment.topLeft,
                  child: Text(descError, style: TextStyle(color: Colors.red.shade700, fontSize: 11))
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: (() {
                    setState(() {
                      nameError = validateBasicTextField(_nameController.text);
                      descError = validateBasicTextField(_descController.text);
                    });
                    if(basicTextFieldIsValid(_nameController.text) && basicTextFieldIsValid(_descController.text)) {
                      String result = _onUpdateButtonClick(context);
                      final snackBar = SnackBar(
                        content: Text(result), 
                        action: SnackBarAction(
                          label: "", 
                          onPressed: (() {})
                        )
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }),
                  child: const Icon(
                    Icons.check,
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
  
  String _onUpdateButtonClick(BuildContext context) {
    try {
      //https://stackoverflow.com/questions/65120125/flutter-texteditingcontroller-clear-wont-reset-the-error-message
      //Future future = 
      Provider.of<TodoList>(context, listen: false).updateTodo(todo.id, _nameController.text, _descController.text);
      Future future = Provider.of<TodoList>(context, listen: false).saveCurrentTodosToRepository();
      future.whenComplete(() {
        Navigator.pop(context);
      });
      return "Le todo ${_nameController.text} a bien été sauveguardé!";
    } catch (e) {
      return "Une erreur est survenu...";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}