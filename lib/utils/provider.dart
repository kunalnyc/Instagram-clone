import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:real_chat/Logic/auth_logic.dart';
import 'package:real_chat/utils/models.dart';

// import 'models.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthLogics _authMethods = AuthLogics();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}