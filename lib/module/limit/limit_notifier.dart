import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:flutter/material.dart';

class LimitNotifier extends ChangeNotifier {
  final BuildContext context;

  LimitNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  int page = 0;
  gantiPage(int value) {
    page = value;
    notifyListeners();
  }
}
