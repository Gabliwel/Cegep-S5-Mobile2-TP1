import 'package:flutter/material.dart';
import 'package:part2/models/todo_list.dart';
import 'package:part2/screens/addScreen.dart';
import 'package:part2/screens/detailScreen.dart';
import 'package:part2/screens/listScreen.dart';
import 'package:part2/screens/updateScreen.dart';
import 'package:part2/services/todo_list_repository.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TodoList todoList = TodoList(repo: TodoListRepositoryDataBase());
    return ChangeNotifierProvider(
      create: (context) => todoList,
      child: const MaterialApp(
        title: 'TP2',
        home: ListScreen(),
      ),
    );
  }
}
