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

String? checkFormatPwd(String? _pwd) {
  if (_pwd == null) return "Mật khẩu hông được để trống";

  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regExp = RegExp(pattern);
  if (_pwd.length < 8) {
    return "Mật khẩu phải dài hơn 8 ký tự";
  } else if (!regExp.hasMatch(_pwd)) {
    return "Mật khẩu phải có một chữ cái hoa và một chữ số";
  }

  return null;
}
