import 'dart:io';

import '../Service/AuthService.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> register({
    required bool isCreateUser,
    required String name,
    required String email,
    required String password,
    required String orgName,
    required String orgEmail,
    required String orgPhone,
    required String lat,
    required String long,
    File? profileImage,
  }) async {
    try {
      await _authService.registerUser(
        isCreateUser: isCreateUser,
        name: name,
        email: email,
        password: password,
        orgName: orgName,
        orgEmail: orgEmail,
        orgPhone: orgPhone,
        lat: lat,
        long: long,
        profileImage: profileImage,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
