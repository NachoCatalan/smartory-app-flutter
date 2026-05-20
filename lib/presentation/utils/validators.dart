import 'dart:convert';

class Validators {
  static bool isEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(email);
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Campo vacío';
    }
    if (!Validators.isEmail(email)) {
      return 'Formato inválido';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Campo vacío';
    }
    return null;
  }

  static String? validatePasswords(String? password, String? confirmPassword) {
    if (password == null || password.trim().isEmpty) {
      return 'Campo vacío';
    }
    if (confirmPassword == null || password.trim().isEmpty) {
      return 'Campo vacío';
    }
    if (password != confirmPassword) {
      return 'Las contraseñas deben coincidir';
    }
    return null;
  }

  static bool isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    final exp = payload['exp'];

    final expireDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expireDate);
  }
}
