import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier{

  bool isAlreadyLogin = false;
  String userName;
  setHasLogin(bool hasLogin){
    isAlreadyLogin = hasLogin;
    notifyListeners();
  }

  setUserName(String userName){
    this.userName = userName;
    notifyListeners();
  }

}