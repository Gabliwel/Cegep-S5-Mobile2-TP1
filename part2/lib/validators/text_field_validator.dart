
const String EMPTY_TEXT_MSG = "Veuillez remplir ce champs";
const String TOO_SHORT_TEXT_MSG = "Veullez saisir au moins 3 charactères";

String validateBasicTextField(String? value) {
  if(value == null || value.isEmpty || value.trim() == "") {
    return EMPTY_TEXT_MSG;
  } else if(value.length < 3) {
    return TOO_SHORT_TEXT_MSG;
  }
  return "";
}

bool basicTextFieldIsValid(String value) {
  if(value.isNotEmpty && value.trim().length >= 3) {
    return true;
  } 
  return false;
}