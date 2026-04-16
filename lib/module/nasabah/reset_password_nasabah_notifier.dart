import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';
import 'package:cms_ibpr/repository/nasabah_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../../utils/informationdialog.dart';

class ResetPasswordNasabahNotifier extends ChangeNotifier {
  final BuildContext context;

  ResetPasswordNasabahNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;

  Future<void> getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  final keyForm = GlobalKey<FormState>();

  TextEditingController userId = TextEditingController();
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController noKtp = TextEditingController();
  TextEditingController noRekening = TextEditingController();
  TextEditingController nomorPonsel = TextEditingController();

  bool get canSubmit =>
      userId.text.trim().isNotEmpty &&
      namaLengkap.text.trim().isNotEmpty &&
      noKtp.text.trim().isNotEmpty &&
      noRekening.text.trim().isNotEmpty &&
      nomorPonsel.text.trim().isNotEmpty;

  void clearForm({bool clearUserId = false}) {
    if (clearUserId) {
      userId.clear();
    }
    namaLengkap.clear();
    noKtp.clear();
    noRekening.clear();
    nomorPonsel.clear();
    notifyListeners();
  }

  void cek() {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  Future<void> simpan() async {
    if (users == null) return;

    DialogCustom().showLoading(context);

    AuthRepository.inquiryUserAccount(
      token,
      NetworkURL.inquiryUserAccount(),
      users!.bprId,
      userId.text.trim(),
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        final data = value['data'] ?? {};

        namaLengkap.text = (data['nama_lengkap'] ?? '').toString();
        noKtp.text = (data['no_ktp'] ?? '').toString();
        noRekening.text = (data['no_rekening'] ?? '').toString();
        nomorPonsel.text = (data['nomor_ponsel'] ?? '').toString();

        notifyListeners();
      } else {
        clearForm();
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  Future<void> generated() async {
    if (users == null) return;

    if (!canSubmit) {
      informationDialog(
        context,
        "Error",
        "Silakan lakukan inquiry user terlebih dahulu.",
      );
      return;
    }

    DialogCustom().showLoading(context);

    NasabahRepository.resetPasswordNasabah(
      token,
      NetworkURL.resetPasswordNasabah(),
      userId.text.trim(),
      users!.bprId,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        clearForm(clearUserId: true);
        informationDialog(context, "Information", value['message']);
      } else {
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  @override
  void dispose() {
    userId.dispose();
    namaLengkap.dispose();
    noKtp.dispose();
    noRekening.dispose();
    nomorPonsel.dispose();
    super.dispose();
  }
}
