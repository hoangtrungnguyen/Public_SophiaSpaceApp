String? checkFormatEmail(String? _email) {
  if (_email == null) {
    return null;
  }
  return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email)
      ? null
      : "Định dạng email sai";
}
