//import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:part2/services/todo_list_repository.dart';

class Todo {
  final int id;
  final String name;
  final String desc;
  final bool isCompleted;

  Todo({required this.id, required this.name, required this.desc, required this.isCompleted});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "isCompleted": isCompleted,
  };

  @override
  String toString() => '''Tâche $id (isCompleted: $isCompleted)''';
}

class TodoList extends ChangeNotifier {
  List<Todo> _todoList = [];
  
  final TodoListRepository _repo;

  List<Todo> get todoList => _todoList;

  TodoList({required TodoListRepository repo}): _repo = repo;

  Future loadTodosFromRepository() async {
    _todoList = await _repo.loadTodos();
  }

  Future saveCurrentTodosToRepository() {
    return _repo.saveTodos(_todoList);
  }

  bool hasTodoById(int id) {
    for(Todo todo in _todoList) {
      if(todo.id == id) {
        return true;
      }
    }
    return false;
  }

  int getUnusedId() {
    int id = 1;
    while(todoList.any((todo) => todo.id == id)) {
      id++;
    }
    return id;
  }

  List<Todo> getTodoOnCompletion(bool completionStatus) {
    List<Todo> list = [];
    for(Todo todo in _todoList) {
      if(todo.isCompleted == completionStatus) {
        list.add(todo);
      }
    }
    return list;
  }

  Todo? getById(int id) {
    return _todoList.firstWhere((todo) => todo.id == id);
  }

  void addTodo(Todo todo) {
    if(!hasTodoById(todo.id)) {
      _todoList.add(todo);
      _repo.saveTodos(_todoList);
    } else {
      throw Exception("Todo id is already in the list");
    }
  }

  Future deleteTodo(int id) {
    if(hasTodoById(id)) {
      _todoList.removeWhere((todo) => todo.id == id);
      return _repo.saveTodos(_todoList);
    } else {
      throw Exception("Todo id is already not in the list");
    }
  }

  void updateTodo(int id, String name, String desc) {
    if(hasTodoById(id)) {
      Todo oldTodo = _todoList.firstWhere((todo) => todo.id == id);
      Todo newTodo = Todo(id: id, name: name, desc: desc, isCompleted: oldTodo.isCompleted);
      _todoList.remove(oldTodo);
      _todoList.add(newTodo);
      //_repo.saveTodos(_todoList); //pas nécessaire selon l'énoncé
    } else {
      throw Exception("Todo id is not in the list");
    }
  }

  void changeTodoStatus(int id, bool newStatus) {
    if(hasTodoById(id)) {
      Todo oldTodo = _todoList.firstWhere((todo) => todo.id == id);
      if(oldTodo.isCompleted != newStatus) {
        Todo newTodo = Todo(id: id, name: oldTodo.name, desc: oldTodo.desc, isCompleted: newStatus);
        _todoList.remove(oldTodo);
        _todoList.add(newTodo);
        // _repo.saveTodos(_todoList); pas nécessaire selon l'énoncé
      } else {
        throw Exception("Todo is already same status");
      }
    } else {
      throw Exception("Todo id is not in the list");
    }
  }

  @override
  String toString() => '''$todoList''';
}