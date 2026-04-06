import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';

import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/informationdialog.dart';

class DaftarKartuNotifier extends ChangeNotifier {
  final BuildContext context;

  DaftarKartuNotifier({required this.context}) {
    getProfile();
  }

  var actionScanner = false;
  var nokartu = "";
  TextEditingController mPinLama = TextEditingController();
  TextEditingController mPinBaru = TextEditingController();
  TextEditingController konfirmMpinBaru = TextEditingController();
  var simpans = false;
  String _enteredPin = '';
  scanner(String value) async {
    Navigator.pop(context);
    // DialogCustom().showLoading(context);
    nokartu = value;
    simpans = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Masukkan PIN Anda", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: PinCodeTextField(
                    autoFocus: true,
                    obscureText: true,
                    appContext: context,
                    length: 6,
                    onChanged: (pin) {
                      _enteredPin = pin;
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box, // Menggunakan kotak
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          print('PIN yang dimasukkan: $_enteredPin');
                          Navigator.pop(context);
                          // await value.validasiPin();
                          await validasiPin();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorPrimary,
                            border: Border.all(width: 2, color: colorPrimary),
                          ),
                          child: Text(
                            'Kirim',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    notifyListeners();
  }

  var mpin = "";
  Future validasiPin() async {
    DialogCustom().showLoading(context);
    var belakangHp = "${noHp.text.toString().substring(noHp.text.length - 4, noHp.text.length)}";
    // print(belakangHp);
    // print(_enteredPin);
    String mPIN = "${(((int.parse((_enteredPin)) * 2) + 999999) - 111111).toString()}$belakangHp";
    // print(token);
    print(mPIN);
    AuthRepository.mPinGeneratedValidated(token, NetworkURL.mPinGeneratedValidated(), users!.bprId, mPIN).then(
      (value) {
        mpin = value['data']['data'];
        AuthRepository.inqueryMpinDev(
          token,
          NetworkURL.inqueryMpinDev(),
          noRek.text,
          users!.bprId,
          mpin,
          noHp.text.trim(),
        ).then((values) {
          Navigator.pop(context);
          if (values['value'] == 1) {
            // simpan();
            AuthRepository.addCardNew(token, NetworkURL.addCardNew(), nokartu, noRek.text, users!.bprId).then((e) {
              // Navigator.pop(context);
              if (e['code'] == "000") {
                // Navigator.pop(context);
                informationDialog(context, "Information", e['message']);
              } else {
                informationDialog(context, "Error", e['message']);
              }
            });
          } else {
            informationDialog(context, "Error", values['message']);
          }
        });
      },
    );
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
      informationDialog(context, "Silahkan Scan Kartu NFC", "Tap Kartu pada NFC Reader");
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
      users!.usersId,
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

  // generated() async {
  //   DialogCustom().showLoading(context);

  //   // print(mpin);
  //   AuthRepository.gantiMpinCMS(
  //     token,
  //     NetworkURL.gantiMpinCMS(),
  //     users!.bprId,
  //     noHp.text,
  //     noRek.text.trim(),
  //     mPinLama.text.trim(),
  //     mPinBaru.text.trim(),
  //   ).then((value) {
  //     Navigator.pop(context);
  //     if (value['value'] == 1) {
  //       namaRek.clear();
  //       noRek.clear();
  //       noKtp.clear();
  //       noHp.clear();
  //       tglLahir.clear();
  //       gender = null;
  //       notifyListeners();
  //       informationDialog(context, "Information", value['message']);
  //     } else {
  //       informationDialog(context, "Error", value['message']);
  //     }
  //   });
  // }
}
