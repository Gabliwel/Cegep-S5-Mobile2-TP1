import 'package:part2/models/todo_list.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

abstract class TodoListRepository {
  Future<List<Todo>> loadTodos();
  Future saveTodos(List<Todo> todos);
}


// https://docs.flutter.dev/cookbook/persistence/reading-writing-files
class TodoListRepositoryDataBase implements TodoListRepository {

  @override
  Future<List<Todo>> loadTodos() async {
    try {
      final file = await _localFile;

      final content = await file.readAsString();

      return List<Todo>.from(json.decode(content).map((x) => Todo.fromJson(x)));
    } catch (e) {

      //donc si le fichier existe pas
      return [];
    }
  }

  @override
  Future saveTodos(List<Todo> todos) async {
    final file = await _localFile;

    final content = json.encode(List<dynamic>.from(todos.map((x) => x.toJson())));

    return file.writeAsString(content);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tpData.json');
  }
}