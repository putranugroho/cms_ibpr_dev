import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';
import 'package:cms_ibpr/repository/users_access_repository.dart';
import 'package:cms_ibpr/utils/dialog_custom.dart';
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
  List<FasilitasAddModel> listFasilitas = [];

  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      if (users != null && (users!.usersId ?? "").toString().isNotEmpty) {
        login();
      } else {
        nothing();
      }
      notifyListeners();
    });
  }

  cek() {
    if (!(keyForm.currentState?.validate() ?? false)) return;

    listFasilitas.clear();
    CustomDialog.loading(context);
    notifyListeners();

    AuthRepository.login(
      token,
      NetworkURL.login(),
      username.text.trim(),
      password.text.trim(),
    ).then((value) async {
      if (value['value'] == 1) {
        try {
          users = UsersModel.fromJson(
            Map<String, dynamic>.from(value['data'] ?? {}),
          );

          await Pref().simpan(users!);

          await checkFasilitas();

          await Pref().setFasilitas(jsonEncode(listFasilitas));

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          login();
        } catch (e) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          CustomDialog.messageResponse(
            context,
            "Gagal memproses data login: $e",
          );
        }
      } else {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        CustomDialog.messageResponse(context, value['message'] ?? "Login gagal");
      }
    }).catchError((e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      CustomDialog.messageResponse(context, e.toString());
    });
  }

  nothing() {}

  login() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
      (route) => false,
    );
  }

  Future<void> checkFasilitas() async {
    listFasilitas.clear();

    if (users == null) return;

    try {
      final value = await UsersAccessRepository.getListFasilitasByUsers(
        token,
        NetworkURL.getListFasilitasByUsers(),
        users!.usersId,
        users!.usersId,
        users!.bprId,
      );

      if (value['value'] == 1) {
        final data = value['data'] ?? [];
        for (final item in data) {
          final i = Map<String, dynamic>.from(item);
          listFasilitas.add(FasilitasAddModel.fromJson(i));
        }

        print("TOTAL RESPONSE API: ${data.length}");

        for (final item in data) {
          print("ITEM: $item");
        }
      }
      print("TOTAL LIST FASILITAS: ${listFasilitas.length}");
    } catch (e) {
      // fasilitas gagal diambil tidak perlu membatalkan login
      // cukup lanjut dengan list kosong
      debugPrint("CHECK FASILITAS ERROR: $e");
    }

    notifyListeners();
  }
}
