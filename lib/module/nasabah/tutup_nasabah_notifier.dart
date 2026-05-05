import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';
import 'package:cms_ibpr/repository/nasabah_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../../utils/informationdialog.dart';

class TutupNasabahNotifier extends ChangeNotifier {
  final BuildContext context;

  TutupNasabahNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
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

  generated() async {
    if (users == null) return;

    if (noHp.text.trim().isEmpty || noRek.text.trim().isEmpty) {
      informationDialog(
        context,
        "Error",
        "Silakan lakukan inquiry nasabah terlebih dahulu.",
      );
      return;
    }

    DialogCustom().showLoading(context);

    NasabahRepository.tutupNasabahGo(
      token,
      NetworkURL.tutupNasabahCms(),
      users!.usersId,
      users!.bprId,
      kdKantor.isNotEmpty ? kdKantor : users!.kodeKantor,
      noKtp.text.trim(),
      namaRek.text.trim(),
      noRek.text.trim(),
      namaRek.text.trim(),
      noHp.text.trim(),
      tglLahir.text.trim(),
      gender ?? "",
      "1",
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        namaRek.clear();
        noRek.clear();
        noKtp.clear();
        noHp.clear();
        tglLahir.clear();
        gender = null;
        kdKantor = "";
        notifyListeners();

        informationDialog(context, "Information", value['message']);
      } else {
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }
}
