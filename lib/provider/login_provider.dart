import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier{

  bool isAlreadyLogin = false;

  setHasLogin(bool hasLogin){
    isAlreadyLogin = hasLogin;
    notifyListeners();
  }

}