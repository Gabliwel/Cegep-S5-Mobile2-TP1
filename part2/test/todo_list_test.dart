import 'package:part2/models/todo_list.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:part2/services/todo_list_repository.dart';

import 'todo_list_test.mocks.dart';

// dart run build_runner build
@GenerateMocks([TodoListRepository])
void main() {
  group('loadTodosFromRepository', () {
    test('can load from repo', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      List<Todo> todos = list.todoList;
      expect(todos.length, 1);
      expect(todos.first, returnedList.first);
    });
  });

  group('hasTodoById', () {
    test('if todo list has id, then returns true', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      bool result = list.hasTodoById(1);
      expect(result, true);
    });

    test('if todo list hasnt id, then returns false', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      bool result = list.hasTodoById(2);
      expect(result, false);
    });
  });
  group('addTodo', () {
    test('can had todo if id doesnt exist in list', () async {
      final repo = MockTodoListRepository();
      final future = Future.value('Stub');
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];
      Todo todoToAdd = Todo(id: 2, name: "name", desc: "desc", isCompleted: false);

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      when(repo.saveTodos([returnedList.first, todoToAdd])).thenAnswer((_) => future);
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      list.addTodo(todoToAdd);
      expect(list.todoList.length, 2);
    });

    test('cant had todo if id exist in list', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];
      Todo todoToAdd = Todo(id: 1, name: "name", desc: "desc", isCompleted: false);

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      expect(() => list.addTodo(todoToAdd), throwsException);
      expect(list.todoList.length, 1);
    });
  });
  group('deleteTodo', () {
    test('can delete todo if id exist in list', () async {
      final repo = MockTodoListRepository();
      final future = Future.value('Stub');
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      when(repo.saveTodos([])).thenAnswer((_) => future);
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      list.deleteTodo(1);
      expect(list.todoList.length, 0);
    });

    test('cant delete todo if id doesnt exist in list', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      expect(() => list.deleteTodo(2), throwsException);
      expect(list.todoList.length, 1);
    });
  });
  group('updateTodoDesc', () {
    test('can update name and desc todo if id exist in list', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      list.updateTodo(1, "name2", "desc2");
      expect(list.todoList.length, 1);
      expect(list.todoList.first.name, "name2");
      expect(list.todoList.first.desc, "desc2");
    });

    test('cant update name and todo desc if id doesnt exist in list', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      expect(() => list.updateTodo(2, "name2", "desc2"), throwsException);
      expect(list.todoList.length, 1);
    });
  });
  group('completeTodo', () {
    test('can complete todo if id exist in list and isnt complete', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      list.changeTodoStatus(1, true);
      expect(list.todoList.length, 1);
      expect(list.todoList.first.isCompleted, true);
    });

    test('can uncomplete todo if id exist in list and is complete', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: true)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      list.changeTodoStatus(1, false);
      expect(list.todoList.length, 1);
      expect(list.todoList.first.isCompleted, false);
    });

    test('cant complete todo if id exist in list and is already complete', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: true)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      expect(() => list.changeTodoStatus(1, true), throwsException);
      expect(list.todoList.length, 1);
    });

    test('cant complete todo if id doesnt exist in list', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: true)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      expect(() => list.changeTodoStatus(2, true), throwsException);
      expect(list.todoList.length, 1);
    });
  });
  group('stringTodoList', () {
    test('stringTodoList is correct when list is empty', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      String result = list.toString();
      expect(result, "[]");
    });

    test('stringTodoList is correct when list is not empty', () async {
      final repo = MockTodoListRepository();
      TodoList list = TodoList(repo: repo);
      List<Todo> returnedList = [Todo(id: 1, name: "name", desc: "desc", isCompleted: false), Todo(id: 2, name: "name", desc: "desc", isCompleted: true)];

      when(repo.loadTodos()).thenAnswer((_) => Future.value(returnedList));
      Future reponse = list.loadTodosFromRepository();
      await reponse;

      String result = list.toString();
      expect(result, "[Tâche 1 (isCompleted: false), Tâche 2 (isCompleted: true)]");
    });
  });
}
