mixin UserValidation {
  bool isEmail(String? value) =>
      value!.isNotEmpty && RegExp(r"^[a-z_]{4,}@esi\.dz$").hasMatch(value);

  bool isPhone(String? value) =>
      value!.isNotEmpty &&
      RegExp(r'^(0|\+213)[5-7]( *[0-9]{2}){4}$').hasMatch(value);

  bool isName(String? value) =>
      value!.isNotEmpty &&
      RegExp(r'^([a-zA-Z])[a-zA-Z0-9_]{3,}$').hasMatch(value);

  bool isCar(String? value) =>
      value!.isNotEmpty && RegExp(r'^[a-zA-Z0-9_]{3,}$').hasMatch(value);

  bool isRegistrationNumber(String? value) =>
      value!.isNotEmpty &&
      RegExp(r'^\d{5,7}-\d{3}-[0-5][0-9]$').hasMatch(value);

  bool isPassword(String? value) =>
      value!.isNotEmpty &&
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$').hasMatch(value);
}
