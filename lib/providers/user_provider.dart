import 'package:flutter/material.dart';
import 'package:instagram_flutter/functions/auth_method.dart';
import 'package:instagram_flutter/models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  AuthMethods _authMethods = new AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}