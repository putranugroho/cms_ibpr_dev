import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:flutter/material.dart';

class DashboardNotifier extends ChangeNotifier {
  final BuildContext context;

  DashboardNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getDashboard();
      notifyListeners();
    });
  }

  Future getDashboard() async {}
}
