import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/auth/login_page.dart';
import 'package:cms_ibpr/network/network.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/utils/dialog_custom.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:cms_ibpr/utils/url.dart';
import 'package:flutter/material.dart';

import '../../repository/auth_repository.dart';
import '../../utils/button_custom.dart';

class MenuNotifier extends ChangeNotifier {
  final BuildContext context;

  MenuNotifier({required this.context}) {
    getProfile();
  }

  final passForm = GlobalKey<FormState>();

  List<FasilitasAddModel> listFasilitas = [];
  UsersModel? users;
  var isloading = true;
  getProfile() async {
    isloading = true;
    listFasilitas.clear();
    notifyListeners();
    Pref().getFasilitas().then((value) {
      // var json = jsonDecode(value);
      var json = jsonDecode(value);
      print("ini = $json");
      for (var i = 0; i < json.length; i++) {
        listFasilitas.add(FasilitasAddModel(
          modul: json[i]['modul'],
          menu: json[i]['menu'],
          submenu: json[i]['submenu'],
          subsubmenu: json[i]['subsubmenu'],
          urut: json[i]['urut'],
          flag: json[i]['flag'],
        ));
      }
      print(listFasilitas.length);
    });
    Pref().getUsers().then((value) {
      users = value;
      isloading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  int page = 0;
  gantipage(int value) {
    page = value;
    notifyListeners();
  }

  confirmDelete() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Konfirmasi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Anda yakin akan keluar dari aplikasi?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ButtonSecondary(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        name: "No",
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: ButtonPrimary(
                        onTap: () {
                          Navigator.pop(context);
                          remove();
                        },
                        name: "Yes",
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  remove() async {
    Pref().remove();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
    notifyListeners();
    // DialogCustom().showLoading(context);
    // AuthRepository.logOut(
    //   NetworkURL.logout(),
    //   users!.bprId,
    //   users!.usersId,
    //   users!.usersId,
    //   "",
    //   "",
    // ).then((value) {
    //   Navigator.pop(context);
    //   if (value['code'] == "000") {
    //     Pref().remove();
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => const LoginPage()),
    //         (route) => false);
    //     notifyListeners();
    //   } else {
    //     CustomDialog.messageResponse(context, value['message']);
    //     notifyListeners();
    //   }
    // });
  }

  TextEditingController passLama = TextEditingController();
  TextEditingController passBaru = TextEditingController();
  TextEditingController confirmpassBaru = TextEditingController();
  TextEditingController passC = TextEditingController();
  gantipassword() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              child: Form(
                key: passForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text("Ganti Password")),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Password Lama",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextFormField(
                      controller: passLama,
                      // obscureText: true,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "wajib diisi";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(hintText: "Password Lama", errorText: ""),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Password Baru",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passBaru,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "wajib diisi";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(hintText: "Password Baru", errorText: ""),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Konfirmasi Password Baru",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passC,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "wajib diisi";
                        } else {
                          if (passBaru.text.trim() != passC.text.trim()) {
                            return "Konfirmasi password harus sama";
                          } else {
                            return null;
                          }
                        }
                      },
                      decoration: const InputDecoration(hintText: "Konfirmasi Password Baru", errorText: ""),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonPrimary(
                      onTap: () {
                        // Navigator.pop(context);
                        confirmPass();
                      },
                      name: "Ganti Sekarang",
                    )
                  ],
                ),
              ),
            ),
          );
        });
    notifyListeners();
  }

  var isLoading = false;
  Future confirmPass() async {
    if (passForm.currentState!.validate()) {
      var passwordBaru = passBaru.text.trim();
      var passwordLama = passLama.text.trim();
      var passwordNC = passC.text.trim();
      DialogCustom().showLoading(context);
      notifyListeners();
      AuthRepository.gantiPassword(token, NetworkURL.gantipassword(), users!.bprId, users!.usersId, encryptString(passwordBaru),
              encryptString(passwordLama), passwordNC, users!.usersId)
          .then((value) {
        Navigator.pop(context);
        if (value['value'] == 1) {
          Navigator.pop(context);
          passBaru.clear();
          passLama.clear();
          passC.clear();
          informationDialog(context, "Informasi", value['message']);
          notifyListeners();
        } else {
          informationDialog(context, "Informasi", value['message']);
          notifyListeners();
        }
      });
    }
  }
}
