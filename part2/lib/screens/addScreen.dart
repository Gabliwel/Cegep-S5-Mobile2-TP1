import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:part2/models/todo_list.dart';
import 'package:part2/screens/listScreen.dart';
import 'package:part2/services/todo_list_repository.dart';
import 'package:part2/validators/text_field_validator.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String nameError = "";
  String descError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un todo")
      ),
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
                    controller: _nameController,
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
                    controller: _descController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder()
                    )
                  ),
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
                      String result = onAddButtonClicked(context);
                      final snackBar = SnackBar(
                        content: Text(result), 
                        action: SnackBarAction(
                          label: "", 
                          onPressed: (() {})
                        )
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      _nameController.text = "";
                      _descController.text = "";
                    }
                  }),
                  child: const Icon(
                    Icons.add_box_outlined,
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
  
  String onAddButtonClicked(BuildContext context) { 
    int id = Provider.of<TodoList>(context, listen: false).getUnusedId();
    Todo todo = Todo(id: id, name: _nameController.text, desc: _descController.text, isCompleted: false);
    
    try {
      Provider.of<TodoList>(context, listen: false).addTodo(todo);
      return "Le todo ${todo.name} a bien été ajouté!";
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