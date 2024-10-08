// Mocks generated by Mockito 5.3.2 from annotations
// in part2/test/widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:part2/models/todo_list.dart' as _i4;
import 'package:part2/services/todo_list_repository.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [TodoListRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTodoListRepository extends _i1.Mock
    implements _i2.TodoListRepository {
  MockTodoListRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Todo>> loadTodos() => (super.noSuchMethod(
        Invocation.method(
          #loadTodos,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Todo>>.value(<_i4.Todo>[]),
      ) as _i3.Future<List<_i4.Todo>>);
  @override
  _i3.Future<dynamic> saveTodos(List<_i4.Todo>? todos) => (super.noSuchMethod(
        Invocation.method(
          #saveTodos,
          [todos],
        ),
        returnValue: _i3.Future<dynamic>.value(),
      ) as _i3.Future<dynamic>);
}
