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

  int debitSourceType;
  int kreditSourceType;

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
    required this.debitSourceType,
    required this.kreditSourceType,
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
    _init();
  }

  UsersModel? users;

  final keyForm = GlobalKey<FormState>();

  List<Map<String, dynamic>> tcodeList = [];
  String? selectedTcode;
  bool showDetail = false;
  bool isExistingSetup = false;

  TextEditingController selectedTcodeController = TextEditingController();
  TextEditingController ketTcode = TextEditingController();

  List<JournalItemModel> journals = [];

  Future<void> _init() async {
    await getProfile();
    await loadMasterTcodes();
  }

  Future<void> getProfile() async {
    users = await Pref().getUsers();
    notifyListeners();
  }

  Future<void> loadMasterTcodes() async {
    if (users == null) return;

    DialogCustom().showLoading(context);

    JournalRepository.getBprProfileWithTcodes(
      NetworkURL.bprProfile(),
      users!.bprId,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        final raw = value['data'] ?? {};
        final tcodes = (raw['tcodes'] as List? ?? []);

        tcodeList = tcodes.where((e) => (Map<String, dynamic>.from(e as Map))['is_linked'] == true).map((e) {
          final row = Map<String, dynamic>.from(e as Map);
          return {
            "code": (row['tcode'] ?? '').toString(),
            "name": (row['keterangan'] ?? '').toString().toUpperCase(),
            "journal_ready": row['journal_ready'] == true,
            "is_linked": row['is_linked'] == true,
          };
        }).toList();

        showDetail = false;
        selectedTcode = null;
        selectedTcodeController.clear();
        ketTcode.clear();
        _clearJournals();
        notifyListeners();
      } else {
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  Future<void> openTcode(Map<String, dynamic> row) async {
    final String tcode = (row['code'] ?? row['tcode'] ?? '').toString();
    final String name = (row['name'] ?? row['keterangan'] ?? '').toString();
    final bool ready = row['journal_ready'] == true;

    selectedTcode = tcode;
    selectedTcodeController.text = tcode;
    ketTcode.text = name;
    isExistingSetup = ready;
    showDetail = true;
    _clearJournals();
    notifyListeners();

    await loadJournalTemplate(tcode);

    if (ready) {
      await overlayExistingSetup(tcode);
    }

    notifyListeners();
  }

  JournalItemModel _createJournalFromTemplate({
    required int journalNo,
    required String keteranganJurnal,
    required int debitSourceType,
    required String debitKeterangan,
    required int kreditSourceType,
    required String kreditKeterangan,
  }) {
    final bool useNasabahDebit = debitSourceType == 1;
    final bool useNasabahKredit = kreditSourceType == 1;

    String mapJenis(int sourceType) {
      if (sourceType == 1) return "Rekening Nasabah";
      if (sourceType == 2) return "GL";
      if (sourceType == 3) return "Rekening";
      return "Rekening";
    }

    return JournalItemModel(
      jnsGl: journalNo.toString(),
      useNasabahDebit: useNasabahDebit,
      useNasabahKredit: useNasabahKredit,
      debitSourceType: debitSourceType,
      kreditSourceType: kreditSourceType,
      debitNoRek: TextEditingController(),
      debitNamaRek: TextEditingController(),
      kreditNoRek: TextEditingController(),
      kreditNamaRek: TextEditingController(),
      keteranganController: TextEditingController(
        text: keteranganJurnal,
      ),
      jenisSbbDebitController: TextEditingController(
        text: mapJenis(debitSourceType),
      ),
      jenisSbbKreditController: TextEditingController(
        text: mapJenis(kreditSourceType),
      ),
      debitSourceController: TextEditingController(
        text: debitKeterangan,
      ),
      kreditSourceController: TextEditingController(
        text: kreditKeterangan,
      ),
    );
  }

  void _clearJournals() {
    for (final item in journals) {
      item.dispose();
    }
    journals = [];
  }

  Future<void> loadJournalTemplate(String tcode) async {
    DialogCustom().showLoading(context);

    JournalRepository.getTcodeJournalDetail(
      NetworkURL.tcodeJournal(),
      tcode,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        final data = value['data'] ?? {};
        final rows = (data['journals'] as List? ?? []);

        _clearJournals();

        for (final raw in rows) {
          final row = Map<String, dynamic>.from(raw as Map);

          journals.add(
            _createJournalFromTemplate(
              journalNo: row['journal_no'] ?? 0,
              keteranganJurnal: (row['keterangan_jurnal'] ?? '').toString().toUpperCase(),
              debitSourceType: row['debit_source_type'] ?? 0,
              debitKeterangan: (row['debit_keterangan'] ?? '').toString(),
              kreditSourceType: row['kredit_source_type'] ?? 0,
              kreditKeterangan: (row['kredit_keterangan'] ?? '').toString(),
            ),
          );
        }

        notifyListeners();
      } else {
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  Future<void> overlayExistingSetup(String tcode) async {
    if (users == null) return;

    DialogCustom().showLoading(context);

    JournalRepository.inquirySetupTransaksiByTcode(
      NetworkURL.setupTransaksiInquiry(),
      users!.usersId,
      users!.bprId,
      "web",
      tcode,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        final rows = (value['data'] as List? ?? []);

        for (final raw in rows) {
          final row = Map<String, dynamic>.from(raw as Map);
          final jnsGl = (row['JnsGL'] ?? '').toString();

          final targetIndex = journals.indexWhere((e) => e.jnsGl == jnsGl);
          if (targetIndex == -1) continue;

          final item = journals[targetIndex];

          item.debitNoRek.text = (row['NosbbDB'] ?? '').toString();
          item.debitNamaRek.text = (row['NmsbbDB'] ?? '').toString();
          item.kreditNoRek.text = (row['NosbbCR'] ?? '').toString();
          item.kreditNamaRek.text = (row['NmsbbCR'] ?? '').toString();

          item.useNasabahDebit = item.debitNoRek.text.trim().isEmpty;
          item.useNasabahKredit = item.kreditNoRek.text.trim().isEmpty;
        }

        notifyListeners();
      } else {
        informationDialog(context, "Error", value['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Error", e.toString());
    });
  }

  String generateRRN() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  String generateDateYYMMDDHHMMSS() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(now.year % 100)}${two(now.month)}${two(now.day)}${two(now.hour)}${two(now.minute)}${two(now.second)}";
  }

  String _mapGlJnsFromSourceType(int sourceType) {
    if (sourceType == 2) return "1";
    return "2";
  }

  String _currentTrxCode() {
    return (selectedTcode ?? "").trim();
  }

  Future<void> inquiryDebit(int index) async {
    if (users == null) return;
    final item = journals[index];

    if (item.useNasabahDebit) return;

    if (item.debitNoRek.text.trim().isEmpty) {
      informationDialog(context, "Error", "Nomor rekening debit wajib diisi");
      return;
    }

    final trxCode = _currentTrxCode();
    if (trxCode.isEmpty) {
      informationDialog(context, "Error", "TCode belum dipilih");
      return;
    }

    DialogCustom().showLoading(context);

    NasabahRepository.inqueryRekCMS(
      token,
      NetworkURL.inqueryRekCMS(),
      users!.usersId,
      users!.bprId,
      trxCode,
      "TRX",
      generateDateYYMMDDHHMMSS(),
      generateDateYYMMDDHHMMSS(),
      generateRRN(),
      item.debitNoRek.text.trim(),
      _mapGlJnsFromSourceType(item.debitSourceType),
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

    final trxCode = _currentTrxCode();
    if (trxCode.isEmpty) {
      informationDialog(context, "Error", "TCode belum dipilih");
      return;
    }

    DialogCustom().showLoading(context);

    NasabahRepository.inqueryRekCMS(
      token,
      NetworkURL.inqueryRekCMS(),
      users!.usersId,
      users!.bprId,
      trxCode,
      "TRX",
      generateDateYYMMDDHHMMSS(),
      generateDateYYMMDDHHMMSS(),
      generateRRN(),
      item.kreditNoRek.text.trim(),
      _mapGlJnsFromSourceType(item.kreditSourceType),
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

    final action = isExistingSetup ? "update" : "insert";

    DialogCustom().showLoading(context);

    JournalRepository.saveSetupTransaksi(
      NetworkURL.setupTransaksi(),
      action,
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
        final idx = tcodeList.indexWhere(
          (e) => (e['code'] ?? '').toString() == selectedTcode,
        );
        if (idx != -1) {
          tcodeList[idx]['journal_ready'] = true;
        }
        isExistingSetup = true;
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

  @override
  void dispose() {
    selectedTcodeController.dispose();
    ketTcode.dispose();
    _clearJournals();
    super.dispose();
  }
}
