import 'package:part2/models/todo_list.dart';
import 'package:part2/validators/text_field_validator.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

void main() {
  group("validateBasicTextField", () {
    test("returns expected value when null", () {
      String? value = null;
      String response = validateBasicTextField(value);
      expect(response, EMPTY_TEXT_MSG);
    });
    test("returns expected value when empty", () {
      String? value = "   ";
      String response = validateBasicTextField(value);
      expect(response, EMPTY_TEXT_MSG);
    });
    test("returns expected value when least then 3 characters", () {
      String? value = "1";
      String response = validateBasicTextField(value);
      expect(response, TOO_SHORT_TEXT_MSG);
    });
    test("returns expected value when valid", () {
      String? value = "valid";
      String response = validateBasicTextField(value);
      expect(response, "");
    });
  });
  group("basicTextFieldIsValid", () {
    test("returns expected value invalid empty", () {
      String value = "";
      bool response = basicTextFieldIsValid(value);
      expect(response, false);
    });
    test("returns expected value when invalid blank", () {
      String value = "     ";
      bool response = basicTextFieldIsValid(value);
      expect(response, false);
    });
    test("returns expected value when invalid too short", () {
      String value = "3";
      bool response = basicTextFieldIsValid(value);
      expect(response, false);
    });
    test("returns expected value when valid", () {
      String value = "valid";
      bool response = basicTextFieldIsValid(value);
      expect(response, true);
    });
  });
}