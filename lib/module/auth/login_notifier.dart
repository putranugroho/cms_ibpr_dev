import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';
import 'package:cms_ibpr/repository/users_access_repository.dart';
import 'package:cms_ibpr/utils/dialog_custom.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/url.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../menu/menu_page.dart';

class LoginNotifier extends ChangeNotifier {
  final BuildContext context;

  LoginNotifier({required this.context}) {
    getProfile();
  }

  var obscure = true;
  gantiobscure() {
    obscure = !obscure;
    notifyListeners();
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      users!.usersId == "" ? nothing() : login();
      notifyListeners();
    });
  }

  List<FasilitasAddModel> listFasilitas = [];
  cek() {
    if (keyForm.currentState!.validate()) {
      listFasilitas.clear();
      DialogCustom().showLoading(context);
      notifyListeners();
      AuthRepository.login(token, NetworkURL.login(), username.text.trim(),
              password.text.trim())
          .then((value) async {
        if (value['value'] == 1) {
          users = UsersModel.fromJson(value['data']);
          for (Map<String, dynamic> i in value['fasilitas']) {
            listFasilitas.add(FasilitasAddModel.fromJson(i));
          }
          Pref().setFasilitas(jsonEncode(listFasilitas));
          Pref().simpan(users!);
          Future.delayed(const Duration(seconds: 3)).then((e) {
            Navigator.pop(context);
            login();
          });
        } else {
          CustomDialog.messageResponse(context, value['message']);
        }
      });
    }
  }

  nothing() {}
  login() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MenuPage()), (route) => false);
  }

  Future checkFasilitas() async {
    listFasilitas.clear();
    UsersAccessRepository.getListFasilitasByUsers(
      token,
      NetworkURL.getListFasilitasByUsers(),
      users!.usersId,
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          listFasilitas.add(FasilitasAddModel.fromJson(i));
        }

        // Pref().getFasilitas().then((e) {
        //   print("e = ${e}");
        // });
        // print(" te = ${Pref().getFasilitas()}");
        // print("ini = ${jsonEncode(listFasilitas)}");
      }
    });
  }
}
