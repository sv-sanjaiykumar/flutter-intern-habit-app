import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';

  String get name => _name;
  String get email => _email;

  void updateUser(String newName, String newEmail) {
    _name = newName;
    _email = newEmail;
    notifyListeners();
  }
}