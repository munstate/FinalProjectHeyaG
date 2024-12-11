import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _email = "";
  String _name = "";

  String get email => _email;
  String get name => _name;

  // 사용자 정보 설정
  void setUser(String email, String name) {
    _email = email;
    _name = name;
    notifyListeners();
  }

  // 로그아웃 시 사용자 정보 초기화
  void clearUser() {
    _email = "";
    _name = "";
    notifyListeners();
  }
}
