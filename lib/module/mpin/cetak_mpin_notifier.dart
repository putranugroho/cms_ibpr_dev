import 'dart:math';
import 'dart:typed_data';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';

import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/mpin_convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
// import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as printing;

import '../../network/network.dart';
import '../../utils/informationdialog.dart';

class CetakMPINNotifier extends ChangeNotifier {
  final BuildContext context;

  CetakMPINNotifier({required this.context}) {
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
  var mpIn = "";
  var kdKantor = "";
  var mPinResult = "";
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
        mPinResult = (value['data']['mpin_cetak'] ?? '').toString();

        String base = mPinResult.length > 4
            ? mPinResult.substring(0, mPinResult.length - 4)
            : mPinResult;

        int baseInt = int.tryParse(base) ?? 0;

        int result = (baseInt - 888888) ~/ 2;

        mpIn = result.toString();
        if (kDebugMode) {
          print("Cetak $mPinResult");
          print("Hasil $mpIn");
        }

        kdKantor = value['data']['kd_kantor'];
        notifyListeners();
      } else {
        informationDialog(context, "Error", value['message']);
      }
    });
  }

  Future<void> generateAndPrintPDF() async {
    if (mPinResult == "") {
      informationDialog(
          context, "Error", "Tidak bisa melakukan cetak ulang MPIN");
    } else {
      DialogCustom().showLoading(context);
      AuthRepository.updateMpinCetak(
        token,
        NetworkURL.updateMpinCetak(),
        users!.bprId,
        noHp.text.trim(),
        noRek.text.trim(),
        users!.usersId,
        kdKantor,
      ).then((value) async {
        Navigator.pop(context);
        if (value['value'] == 1) {
          final pdf = pw.Document();

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (context) => pw.Container(
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      "MPIN Nasabah",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 12),
                    ),
                    pw.SizedBox(height: 20),
                    _buildRow("Nama Nasabah", namaRek.text.trim()),
                    _buildDivider(),
                    pw.SizedBox(height: 10),
                    _buildRow("No Rekening", noRek.text.trim()),
                    _buildDivider(),
                    pw.SizedBox(height: 10),
                    _buildRow("Nomor Ponsel", noHp.text.trim()),
                    _buildDivider(),
                    pw.SizedBox(height: 10),
                    _buildRow(
                        "MPIN", ConvertMpin().numberToWordsPerCharacter(mpIn)),
                    _buildDivider(),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      "Harap untuk selalu menjaga kerahasiaan data MPIN anda.",
                      style: const pw.TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          );

          final Uint8List bytes = await pdf.save();

          await printing.Printing.layoutPdf(
            onLayout: (format) async => bytes,
            name: 'data_mpin_${noHp.text.trim()}.pdf',
          );
        } else {
          informationDialog(context, "Error", value['message']);
        }
      }).catchError((e) {
        Navigator.pop(context);
        informationDialog(context, "Error", e.toString());
      });
    }
  }

  pw.Widget _buildRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        pw.Text(
          value,
          textAlign: pw.TextAlign.left,
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  pw.Divider _buildDivider() {
    return pw.Divider(
      height: 1,
      color: PdfColors.grey,
    );
  }

  generated() async {
    if (noHp.text.trim().isEmpty ||
        noRek.text.trim().isEmpty ||
        kdKantor.trim().isEmpty) {
      informationDialog(context, "Error", "Data nasabah belum lengkap");
      return;
    }

    DialogCustom().showLoading(context);

    AuthRepository.generatedMPIN(
      token,
      NetworkURL.generatedMpin(),
      users!.usersId,
      kdKantor,
      users!.bprId,
      noHp.text.trim(),
      noRek.text.trim(),
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
