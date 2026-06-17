import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/network/network.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/laporan_repository.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanNotifier extends ChangeNotifier {
  final BuildContext context;
  final String initialReport;

  LaporanNotifier({
    required this.context,
    this.initialReport = "user_access",
  }) {
    _initTanggalDefault();
    getProfile();
  }

  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");

  UsersModel? users;

  bool isLoadingUserAccess = false;
  bool isLoadingAkun = false;
  bool isLoadingTransaksi = false;

  List<LaporanUserAccessItem> listUserAccess = [];
  List<LaporanAkunIbprItem> listAkunMaster = [];
  List<LaporanAkunIbprItem> listAkun = [];
  List<LaporanTrxItem> listTransaksi = [];

  String akunStatus = "ALL";
  bool akunUseTanggal = true;
  final TextEditingController akunTanggal = TextEditingController();

  String transaksiAkunKey = "ALL";
  final TextEditingController transaksiTglAwal = TextEditingController();
  final TextEditingController transaksiTglAkhir = TextEditingController();

  void _initTanggalDefault() {
    final today = _dateFormat.format(DateTime.now());
    akunTanggal.text = today;
    transaksiTglAwal.text = today;
    transaksiTglAkhir.text = today;
  }

  Future<void> getProfile() async {
    users = await Pref().getUsers();

    if (users == null) {
      notifyListeners();
      return;
    }

    // Karena laporan sekarang dipisah menjadi 3 menu,
    // load data hanya sesuai halaman yang sedang dibuka.
    if (initialReport == "user_access") {
      await getUserAccessReport(showError: false);
      return;
    }

    if (initialReport == "akun_ibpr") {
      await getAkunIbprReport(showError: false);
      return;
    }

    if (initialReport == "transaksi") {
      // Laporan transaksi tetap butuh daftar akun untuk dropdown filter Akun / ALL.
      await getAkunIbprReport(showError: false);
      await getTransaksiReport(showError: false);
      return;
    }

    await Future.wait([
      getUserAccessReport(showError: false),
      getAkunIbprReport(showError: false),
    ]);

    await getTransaksiReport(showError: false);
  }

  List<String> get akunStatusOptions {
    final statuses = <String>{"ALL"};
    for (final item in listAkunMaster) {
      final status = item.statusLabel.trim().toUpperCase();
      if (status.isNotEmpty && status != "-") {
        statuses.add(status);
      }
    }
    return statuses.toList()..sort((a, b) {
      if (a == "ALL") return -1;
      if (b == "ALL") return 1;
      return laporanStatusRank(a).compareTo(laporanStatusRank(b));
    });
  }

  List<DropdownMenuItem<String>> get transaksiAkunItems {
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem(
        value: "ALL",
        child: Text("ALL - Semua Akun"),
      ),
    ];

    final seen = <String>{"ALL"};
    for (final item in listAkunMaster) {
      if (item.key.trim() == "|") continue;
      if (seen.contains(item.key)) continue;
      seen.add(item.key);
      items.add(
        DropdownMenuItem(
          value: item.key,
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return items;
  }

  LaporanAkunIbprItem? get selectedTransaksiAkun {
    if (transaksiAkunKey == "ALL") return null;

    for (final item in listAkunMaster) {
      if (item.key == transaksiAkunKey) return item;
    }

    return null;
  }

  String get transaksiKeyword {
    final akun = selectedTransaksiAkun;
    if (akun == null) return "";
    if (akun.noRek.trim().isNotEmpty) return akun.noRek.trim();
    if (akun.noHp.trim().isNotEmpty) return akun.noHp.trim();
    return "";
  }

  Future<void> getUserAccessReport({bool showError = true}) async {
    if (users == null) return;

    isLoadingUserAccess = true;
    notifyListeners();

    try {
      final result = await LaporanRepository.getUserAccessReport(
        url: NetworkURL.getUsersAccess(),
        username: users!.usersId,
        bprId: users!.bprId,
      );

      final rawData = result["data"];
      final data = <LaporanUserAccessItem>[];

      if (rawData is List) {
        for (final raw in rawData) {
          final row = Map<String, dynamic>.from(raw);
          final item = LaporanUserAccessItem.fromJson(row);
          if (!item.isHapus) {
            data.add(item);
          }
        }
      }

      data.sort((a, b) {
        final statusSort = laporanStatusRank(a.statusLabel).compareTo(laporanStatusRank(b.statusLabel));
        if (statusSort != 0) return statusSort;
        return a.namauser.toLowerCase().compareTo(b.namauser.toLowerCase());
      });

      listUserAccess = data;
    } catch (e) {
      if (showError) {
        informationDialog(context, "Error", e.toString());
      }
    }

    isLoadingUserAccess = false;
    notifyListeners();
  }

  Future<void> getAkunIbprReport({bool showError = true}) async {
    if (users == null) return;

    isLoadingAkun = true;
    notifyListeners();

    try {
      final result = await LaporanRepository.getAkunIbprReport(
        url: NetworkURL.getListNasbah(),
        username: users!.usersId,
        bprId: users!.bprId,
        kdKantor: users!.kodeKantor,
        status: akunStatus,
        useTanggal: akunUseTanggal,
        tanggal: akunTanggal.text.trim(),
      );

      final rawData = result["data"];
      final data = <LaporanAkunIbprItem>[];

      if (rawData is List) {
        for (final raw in rawData) {
          final row = Map<String, dynamic>.from(raw);
          data.add(LaporanAkunIbprItem.fromJson(row));
        }
      }

      listAkunMaster = data;
      _applyAkunFilterAndSort();

      if (transaksiAkunKey != "ALL" && selectedTransaksiAkun == null) {
        transaksiAkunKey = "ALL";
      }
    } catch (e) {
      if (showError) {
        informationDialog(context, "Error", e.toString());
      }
    }

    isLoadingAkun = false;
    notifyListeners();
  }

  void _applyAkunFilterAndSort() {
    final selectedStatus = akunStatus.trim().toUpperCase();
    final targetTanggal = akunTanggal.text.trim();

    listAkun = listAkunMaster.where((item) {
      final matchStatus = selectedStatus == "ALL" || item.statusLabel == selectedStatus;
      if (!matchStatus) return false;

      if (!akunUseTanggal) return true;
      if (targetTanggal.isEmpty) return true;

      final itemDate = _normalizeDateOnly(item.tglData);
      if (itemDate.isEmpty) {
        // Jika response account belum menyediakan field tanggal, jangan paksa data jadi kosong.
        // Filter tanggal tetap dikirim ke backend melalui request tgl_awal/tgl_akhir.
        return true;
      }

      return itemDate == targetTanggal;
    }).toList();

    listAkun.sort((a, b) {
      final statusSort = laporanStatusRank(a.statusLabel).compareTo(laporanStatusRank(b.statusLabel));
      if (statusSort != 0) return statusSort;

      final namaA = a.nama.trim().isNotEmpty ? a.nama : a.namaRek;
      final namaB = b.nama.trim().isNotEmpty ? b.nama : b.namaRek;
      return namaA.toLowerCase().compareTo(namaB.toLowerCase());
    });
  }

  String _normalizeDateOnly(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return "";

    try {
      final normalized = raw.contains("T") ? raw : raw.replaceFirst(" ", "T");
      return _dateFormat.format(DateTime.parse(normalized));
    } catch (_) {
      if (raw.length >= 10) return raw.substring(0, 10);
      return raw;
    }
  }

  void pilihStatusAkun(String value) {
    akunStatus = value;
    _applyAkunFilterAndSort();
    notifyListeners();
  }

  void toggleTanggalAkun(bool value) {
    akunUseTanggal = value;
    _applyAkunFilterAndSort();
    notifyListeners();
  }

  Future<void> pilihTanggalAkun() async {
    final picked = await _pickDate(akunTanggal.text);
    if (picked == null) return;

    akunTanggal.text = _dateFormat.format(picked);
    _applyAkunFilterAndSort();
    notifyListeners();
  }

  Future<void> getTransaksiReport({bool showError = true}) async {
    if (users == null) return;

    isLoadingTransaksi = true;
    notifyListeners();

    try {
      final result = await LaporanRepository.getTrxLogReport(
        url: NetworkURL.trxLog(),
        username: users!.usersId,
        bprId: users!.bprId,
        keyword: transaksiKeyword,
        tglAwal: transaksiTglAwal.text.trim(),
        tglAkhir: transaksiTglAkhir.text.trim(),
      );

      final rawData = result["data"];
      final data = <LaporanTrxItem>[];

      if (rawData is List) {
        for (final raw in rawData) {
          final row = Map<String, dynamic>.from(raw);
          data.add(LaporanTrxItem.fromJson(row));
        }
      }

      listTransaksi = data;
    } catch (e) {
      if (showError) {
        informationDialog(context, "Error", e.toString());
      }
    }

    isLoadingTransaksi = false;
    notifyListeners();
  }

  void pilihTransaksiAkun(String value) {
    transaksiAkunKey = value;
    notifyListeners();
  }

  Future<void> pilihTanggalTransaksiAwal() async {
    final picked = await _pickDate(transaksiTglAwal.text);
    if (picked == null) return;

    transaksiTglAwal.text = _dateFormat.format(picked);

    final awal = _tryParseDate(transaksiTglAwal.text);
    final akhir = _tryParseDate(transaksiTglAkhir.text);
    if (awal != null && akhir != null && awal.isAfter(akhir)) {
      transaksiTglAkhir.text = transaksiTglAwal.text;
    }

    notifyListeners();
  }

  Future<void> pilihTanggalTransaksiAkhir() async {
    final picked = await _pickDate(transaksiTglAkhir.text);
    if (picked == null) return;

    transaksiTglAkhir.text = _dateFormat.format(picked);

    final awal = _tryParseDate(transaksiTglAwal.text);
    final akhir = _tryParseDate(transaksiTglAkhir.text);
    if (awal != null && akhir != null && akhir.isBefore(awal)) {
      transaksiTglAwal.text = transaksiTglAkhir.text;
    }

    notifyListeners();
  }

  DateTime? _tryParseDate(String value) {
    try {
      return _dateFormat.parseStrict(value.trim());
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> _pickDate(String currentValue) async {
    final current = _tryParseDate(currentValue) ?? DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );
  }

  @override
  void dispose() {
    akunTanggal.dispose();
    transaksiTglAwal.dispose();
    transaksiTglAkhir.dispose();
    super.dispose();
  }
}
