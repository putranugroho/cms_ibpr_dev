import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';

import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../network/network.dart';
import '../../utils/informationdialog.dart';

class GantiMPINNotifier extends ChangeNotifier {
  final BuildContext context;

  GantiMPINNotifier({required this.context}) {
    getProfile();
  }

  var actionScanner = false;
  var nokartu = "";
  TextEditingController mPinLama = TextEditingController();
  TextEditingController mPinBaru = TextEditingController();
  TextEditingController konfirmMpinBaru = TextEditingController();

  scanner(String value) async {
    Navigator.pop(context);
    DialogCustom().showLoading(context);
    nokartu = value;
    AuthRepository.validateCard(token, NetworkURL.validateCard(),
            noRek.text.trim(), nokartu, users!.bprId)
        .then((value) {
      Navigator.pop(context);
      // print(value);
      if (value['code'] == '000') {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 500,
                  child: Form(
                    key: mpinForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text("Ganti MPIN")),
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
                          "MPIN Lama",
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          maxLength: 6,
                          controller: mPinLama,
                          obscureText: true,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "wajib diisi";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "MPIN Lama", errorText: ""),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "MPIN Baru",
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          maxLength: 6,
                          obscureText: true,
                          controller: mPinBaru,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "wajib diisi";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "MPIN Baru", errorText: ""),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Konfirmasi MPIN Baru",
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          maxLength: 6,
                          obscureText: true,
                          controller: konfirmMpinBaru,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "wajib diisi";
                            } else {
                              if (mPinBaru.text.trim() !=
                                  konfirmMpinBaru.text.trim()) {
                                return "Konfirmasi MPIN harus sama";
                              } else {
                                return null;
                              }
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "Konfirmasi PIN Baru", errorText: ""),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ButtonPrimary(
                          onTap: () {
                            // Navigator.pop(context);
                            confirm();
                          },
                          name: "Ganti Sekarang",
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        informationDialog(context, 'Gagal', value['message']);
        // CustomDialog.messageResponse(context, value['message']);
      }
    });
    notifyListeners();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  bool isScanner = false;
  //untuk enable
  void setScanner(bool success) {
    //enable dialog scanner
    isScanner = success;
    if (isScanner) {
      informationDialog(
          context, "Silahkan Scan Kartu NFC", "Tap Kartu pada NFC Reader");
      actionScanner = true;
    } else {}
    notifyListeners();
  }

  gantiGender(String value) {
    gender = value;
    notifyListeners();
  }

  TextEditingController noRek = TextEditingController();
  TextEditingController noKtp = TextEditingController();
  TextEditingController noHp = TextEditingController();
  TextEditingController tglLahir = TextEditingController();
  String? gender;
  TextEditingController namaRek = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  final passForm = GlobalKey<FormState>();
  final mpinForm = GlobalKey<FormState>();
  cek() {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  // var noHp = "";
  var kdKantor = "";
  simpan() async {
    DialogCustom().showLoading(context);
    // noHp = "";
    // kdKantor = "";
    // var invoice = DateTime.now().microsecondsSinceEpoch.toString();
    AuthRepository.inqueryHp(
      token,
      NetworkURL.inqueryHp(),
      users!.bprId,
      noHp.text.trim(),
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        namaRek.text = value['data']['nama_rek'];
        noRek.text = value['data']['no_rek'];
        noKtp.text = value['data']['no_ktp'];
        noHp.text = value['data']['no_hp'];
        tglLahir.text = value['data']['tgl_lahir'];
        gender = value['data']['gender'];
        // print(gender);
        kdKantor = value['data']['kd_kantor'];
        notifyListeners();
      } else {
        informationDialog(context, "Error", value['message']);
      }
    });
  }

  confirm() {
    if (mpinForm.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: passForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Masukan PASSWORD Username Anda",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: password,
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Wajib diisi";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(hintText: "Password"),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      ButtonPrimary(
                        onTap: () {
                          // Navigator.pop(context);
                          validasiUser();
                        },
                        name: "Konfirmasi",
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  TextEditingController password = TextEditingController();
  String pesan = "";
  validasiUser() async {
    if (passForm.currentState!.validate()) {
      AuthRepository.login(
              token, NetworkURL.login(), users!.usersId, password.text.trim())
          .then((value) async {
        Navigator.pop(context);
        if (value['value'] == 1) {
          await generated();
        } else {
          if (value['message'] == "Password atau usersname tidak tepat") {
            pesan = "Password tidak tepat";
          } else {
            pesan = value['message'];
          }
          password.clear();
          informationDialog(context, "Information", pesan);
        }
      });
    }
  }

  generated() async {
    DialogCustom().showLoading(context);
    // print(mpin);
    var belakangHp =
        "${noHp.text.toString().substring(noHp.text.length - 4, noHp.text.length)}";
    // print(belakangHp);
    // print(_enteredPin);
    String mPINLama =
        "${(((int.parse((mPinLama.text)) * 2) + 999999) - 111111).toString()}$belakangHp";
    String mPINBaru =
        "${(((int.parse((mPinBaru.text)) * 2) + 999999) - 111111).toString()}$belakangHp";
    AuthRepository.mPinGeneratedValidated(
            token, NetworkURL.mPinGeneratedValidated(), users!.bprId, mPINLama)
        .then((value) {
      var mpinLamaNew = value['data']['data'];

      AuthRepository.mPinGeneratedValidated(token,
              NetworkURL.mPinGeneratedValidated(), users!.bprId, mPINBaru)
          .then((values) {
        var mPinBaruNew = values['data']['data'];
        AuthRepository.gantiMpinCMS(
          token,
          NetworkURL.gantiMpinCMS(),
          users!.usersId,
          users!.bprId,
          noHp.text,
          noRek.text.trim(),
          mpinLamaNew,
          mPinBaruNew,
        ).then((e) {
          Navigator.pop(context);
          if (e['value'] == 1) {
            Navigator.pop(context);
            namaRek.clear();
            noRek.clear();
            noKtp.clear();
            noHp.clear();
            tglLahir.clear();
            gender = null;
            mPinLama.clear();
            mPinBaru.clear;
            konfirmMpinBaru.clear();
            notifyListeners();
            informationDialog(context, "Information", e['message']);
          } else {
            informationDialog(context, "Error", e['message']);
          }
        });
      });
    });
  }
}
