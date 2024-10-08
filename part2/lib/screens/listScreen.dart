import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:part2/models/todo_list.dart';
import 'package:part2/screens/addScreen.dart';
import 'package:part2/screens/detailScreen.dart';
import 'package:part2/services/todo_list_repository.dart';
import 'package:part2/utils/helper.dart';
import 'package:part2/widgets/todos_list.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
  TodoSort _currentChoice = TodoSort.all;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  void _firstLoad() async {
    Future future = Provider.of<TodoList>(context, listen: false).loadTodosFromRepository();
    await future.whenComplete(() => 
      setState(() {
        todos = Provider.of<TodoList>(context, listen: false).todoList;
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de todo"),
        actions: [
          PopupMenuButton(
            onSelected: _onChangedFilter,
            icon: const Icon(Icons.sort),
            offset: const Offset(0, 100),
            itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: TodoSort.all,
                        child: Text('Par défaut'),
                      ),
                      const PopupMenuItem(
                        value: TodoSort.completed,
                        child: Text('Complété'),
                      ),
                      const PopupMenuItem(
                        value: TodoSort.notCompleted,
                        child: Text('Non complété'),
                      )
            ]
          )
        ],
      ),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodosListElement(todo: todos[index], function: refreshList,key: UniqueKey(),);
                  },
                ),
              )
          
              /*ListView(
                children: [
                  for (Todo todo in todos)
                    if(_currentChoice == TodoSort.all || (_currentChoice == TodoSort.completed && todo.isCompleted == true) || (_currentChoice == TodoSort.notCompleted && todo.isCompleted == false))
                      TodosListElement(todo: todo, function: refreshList),
                ],*/
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddScreen())
                  ).then((_) => refreshList()),
                  child: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.black87,
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  void _onChangedFilter(TodoSort choice) {
    if (choice != _currentChoice) {
      setState(() {
        _currentChoice = choice;
        todos = [];
      });
      refreshList();
    }
  }

  refreshList() {
      if(_currentChoice == TodoSort.all) { 
        setState(() {
          todos = Provider.of<TodoList>(context, listen: false).todoList;
        });
      } else if(_currentChoice == TodoSort.completed) {
        setState(() {
          todos = new List<Todo>.from(Provider.of<TodoList>(context, listen: false).getTodoOnCompletion(true).toList());
        });
        log(todos.toString());
      } else if (_currentChoice == TodoSort.notCompleted) {
        setState(() {
          todos = new List<Todo>.from(Provider.of<TodoList>(context, listen: false).getTodoOnCompletion(false).toList());
        });
      }
  }
}
