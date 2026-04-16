import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/journal_repository.dart';
import 'package:cms_ibpr/repository/nasabah_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../../utils/informationdialog.dart';

class JournalItemModel {
  String jnsGl;
  bool useNasabahDebit;
  bool useNasabahKredit;

  TextEditingController debitNoRek;
  TextEditingController debitNamaRek;
  TextEditingController kreditNoRek;
  TextEditingController kreditNamaRek;
  TextEditingController keteranganController;
  TextEditingController jenisSbbDebitController;
  TextEditingController jenisSbbKreditController;
  TextEditingController debitSourceController;
  TextEditingController kreditSourceController;

  JournalItemModel({
    required this.jnsGl,
    required this.useNasabahDebit,
    required this.useNasabahKredit,
    required this.debitNoRek,
    required this.debitNamaRek,
    required this.kreditNoRek,
    required this.kreditNamaRek,
    required this.keteranganController,
    required this.jenisSbbDebitController,
    required this.jenisSbbKreditController,
    required this.debitSourceController,
    required this.kreditSourceController,
  });

  void dispose() {
    debitNoRek.dispose();
    debitNamaRek.dispose();
    kreditNoRek.dispose();
    kreditNamaRek.dispose();
    keteranganController.dispose();
    jenisSbbDebitController.dispose();
    jenisSbbKreditController.dispose();
    debitSourceController.dispose();
    kreditSourceController.dispose();
  }
}

class SetupJournalTransaksiNotifier extends ChangeNotifier {
  final BuildContext context;

  SetupJournalTransaksiNotifier({required this.context}) {
    getProfile();
    initTcode();
    loadDummyTemplate();
  }

  UsersModel? users;

  Future<void> getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  final keyForm = GlobalKey<FormState>();

  final List<Map<String, String>> tcodeList = [
    {"code": "2100", "name": "TRANSFER OUT"},
    {"code": "2200", "name": "TRANSFER IN"},
    {"code": "2300", "name": "PINDAH BUKU"},
    {"code": "4000", "name": "TARIK TUNAI"},
    {"code": "5000", "name": "PPOB"},
  ];

  String? selectedTcode;
  TextEditingController ketTcode = TextEditingController();

  List<JournalItemModel> journals = [];

  void initTcode() {
    if (tcodeList.isNotEmpty) {
      selectedTcode = tcodeList.first['code'];
      ketTcode.text = tcodeList.first['name'] ?? '';
    }
  }

  void changeTcode(String code) {
    selectedTcode = code;
    final item = tcodeList.firstWhere(
      (e) => e['code'] == code,
      orElse: () => {"code": "", "name": ""},
    );
    ketTcode.text = item['name'] ?? '';
    loadDummyTemplate();
    notifyListeners();
  }

  JournalItemModel _makeJournal({
    required String jnsGl,
    required String keterangan,
    required bool useNasabahDebit,
    required bool useNasabahKredit,
    required String jenisSbbDebitText,
    required String jenisSbbKreditText,
    required String debitSourceText,
    required String kreditSourceText,
  }) {
    return JournalItemModel(
      jnsGl: jnsGl,
      useNasabahDebit: useNasabahDebit,
      useNasabahKredit: useNasabahKredit,
      debitNoRek: TextEditingController(),
      debitNamaRek: TextEditingController(),
      kreditNoRek: TextEditingController(),
      kreditNamaRek: TextEditingController(),
      keteranganController: TextEditingController(text: keterangan),
      jenisSbbDebitController: TextEditingController(text: jenisSbbDebitText),
      jenisSbbKreditController: TextEditingController(text: jenisSbbKreditText),
      debitSourceController: TextEditingController(text: debitSourceText),
      kreditSourceController: TextEditingController(text: kreditSourceText),
    );
  }

  void _clearJournals() {
    for (final item in journals) {
      item.dispose();
    }
    journals = [];
  }

  void loadDummyTemplate() {
    _clearJournals();

    switch (selectedTcode) {
      case "5000":
        journals = [
          _makeJournal(
            jnsGl: "0",
            keterangan: "Pokok",
            useNasabahDebit: true,
            useNasabahKredit: false,
            jenisSbbDebitText: "Rekening Nasabah",
            jenisSbbKreditText: "GL",
            debitSourceText: "Menggunakan nomor rekening nasabah",
            kreditSourceText: "Menggunakan nomor rekening MTD",
          ),
          _makeJournal(
            jnsGl: "1",
            keterangan: "Fee MTD",
            useNasabahDebit: false,
            useNasabahKredit: false,
            jenisSbbDebitText: "Rekening MTD",
            jenisSbbKreditText: "Rekening MTD",
            debitSourceText: "Menggunakan nomor rekening MTD",
            kreditSourceText: "Menggunakan nomor rekening FEE MTD",
          ),
          _makeJournal(
            jnsGl: "2",
            keterangan: "Fee BPR",
            useNasabahDebit: false,
            useNasabahKredit: false,
            jenisSbbDebitText: "Rekening MTD",
            jenisSbbKreditText: "Rekening MTD",
            debitSourceText: "Menggunakan nomor rekening MTD",
            kreditSourceText: "Menggunakan nomor rekening FEE BPR",
          ),
        ];
        break;

      case "2100":
        journals = [
          _makeJournal(
            jnsGl: "0",
            keterangan: "Pokok",
            useNasabahDebit: false,
            useNasabahKredit: true,
            jenisSbbDebitText: "GL",
            jenisSbbKreditText: "Rekening",
            debitSourceText: "Menggunakan nomor rekening penampung transfer out",
            kreditSourceText: "Menggunakan nomor rekening nasabah",
          ),
        ];
        break;

      case "2200":
        journals = [
          _makeJournal(
            jnsGl: "0",
            keterangan: "Pokok",
            useNasabahDebit: true,
            useNasabahKredit: false,
            jenisSbbDebitText: "Rekening",
            jenisSbbKreditText: "GL",
            debitSourceText: "Menggunakan nomor rekening nasabah",
            kreditSourceText: "Menggunakan nomor rekening penampung transfer in",
          ),
        ];
        break;

      case "2300":
        journals = [
          _makeJournal(
            jnsGl: "0",
            keterangan: "Pokok",
            useNasabahDebit: true,
            useNasabahKredit: true,
            jenisSbbDebitText: "Rekening",
            jenisSbbKreditText: "Rekening",
            debitSourceText: "Menggunakan nomor rekening nasabah",
            kreditSourceText: "Menggunakan nomor rekening nasabah",
          ),
        ];
        break;

      case "4000":
        journals = [
          _makeJournal(
            jnsGl: "0",
            keterangan: "Pokok",
            useNasabahDebit: false,
            useNasabahKredit: true,
            jenisSbbDebitText: "GL",
            jenisSbbKreditText: "Rekening",
            debitSourceText: "Menggunakan nomor rekening kas/teller",
            kreditSourceText: "Menggunakan nomor rekening nasabah",
          ),
        ];
        break;

      default:
        journals = [
          _makeJournal(
            jnsGl: "0",
            keterangan: "Pokok",
            useNasabahDebit: false,
            useNasabahKredit: false,
            jenisSbbDebitText: "GL",
            jenisSbbKreditText: "GL",
            debitSourceText: "Menggunakan nomor rekening debit",
            kreditSourceText: "Menggunakan nomor rekening kredit",
          ),
        ];
    }

    notifyListeners();
  }

  String generateRRN() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  String generateDateYYMMDDHHMMSS() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(now.year % 100)}${two(now.month)}${two(now.day)}${two(now.hour)}${two(now.minute)}${two(now.second)}";
  }

  Future<void> inquiryDebit(int index) async {
    if (users == null) return;
    final item = journals[index];

    if (item.useNasabahDebit) return;

    if (item.debitNoRek.text.trim().isEmpty) {
      informationDialog(context, "Error", "Nomor rekening debit wajib diisi");
      return;
    }

    DialogCustom().showLoading(context);

    NasabahRepository.inqueryRekCMS(
      token,
      NetworkURL.inqueryRekCMS(),
      users!.usersId,
      users!.bprId,
      "1000",
      "I",
      generateDateYYMMDDHHMMSS(),
      generateDateYYMMDDHHMMSS(),
      generateRRN(),
      item.debitNoRek.text.trim(),
      "D",
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        final data = value['data'] ?? {};
        item.debitNamaRek.text = (data['nama_rek'] ?? data['namaRek'] ?? data['nama'] ?? '').toString();
        notifyListeners();
      } else {
        item.debitNamaRek.clear();
        notifyListeners();
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  Future<void> inquiryKredit(int index) async {
    if (users == null) return;
    final item = journals[index];

    if (item.useNasabahKredit) return;

    if (item.kreditNoRek.text.trim().isEmpty) {
      informationDialog(context, "Error", "Nomor rekening kredit wajib diisi");
      return;
    }

    DialogCustom().showLoading(context);

    NasabahRepository.inqueryRekCMS(
      token,
      NetworkURL.inqueryRekCMS(),
      users!.usersId,
      users!.bprId,
      "1000",
      "I",
      generateDateYYMMDDHHMMSS(),
      generateDateYYMMDDHHMMSS(),
      generateRRN(),
      item.kreditNoRek.text.trim(),
      "K",
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        final data = value['data'] ?? {};
        item.kreditNamaRek.text = (data['nama_rek'] ?? data['namaRek'] ?? data['nama'] ?? '').toString();
        notifyListeners();
      } else {
        item.kreditNamaRek.clear();
        notifyListeners();
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  Future<void> submit() async {
    if (users == null) return;

    if (!keyForm.currentState!.validate()) {
      return;
    }

    if (selectedTcode == null || selectedTcode!.isEmpty) {
      informationDialog(context, "Error", "TCode wajib dipilih");
      return;
    }

    for (int i = 0; i < journals.length; i++) {
      final item = journals[i];

      final bool debitValid = item.useNasabahDebit || (item.debitNoRek.text.trim().isNotEmpty && item.debitNamaRek.text.trim().isNotEmpty);

      final bool kreditValid = item.useNasabahKredit || (item.kreditNoRek.text.trim().isNotEmpty && item.kreditNamaRek.text.trim().isNotEmpty);

      if (!debitValid) {
        informationDialog(
          context,
          "Error",
          "Jurnal ${i + 1} sisi debit belum lengkap.",
        );
        return;
      }

      if (!kreditValid) {
        informationDialog(
          context,
          "Error",
          "Jurnal ${i + 1} sisi kredit belum lengkap.",
        );
        return;
      }
    }

    DialogCustom().showLoading(context);

    JournalRepository.saveSetupTransaksi(
      NetworkURL.setupTransaksi(),
      users!.usersId,
      users!.bprId,
      "web",
      users!.kodeKantor,
      selectedTcode!,
      ketTcode.text.trim(),
      journals,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
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
    ketTcode.dispose();
    _clearJournals();
    super.dispose();
  }
}
