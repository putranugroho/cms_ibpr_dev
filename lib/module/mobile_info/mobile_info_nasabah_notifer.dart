import 'dart:math';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/network/network.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/auth_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UsersInfoNotifier extends ChangeNotifier {
  final BuildContext context;
  late final UsersInfoDataSource dataSource;

  UsersInfoNotifier({required this.context}) {
    dataSource = UsersInfoDataSource();
    _init();
  }

  /* =====================
      STATE
  ====================== */
  // String? token;
  String bprId = "";
  bool isLoading = true;

  int page = 1;
  int limit = 20;
  int total = 0;

  TextEditingController cariCtrl = TextEditingController();
  List<Map<String, dynamic>> list = [];

  int get totalPages {
    final p = (total / limit).ceil();
    return max(p, 1);
  }

  final keyForm = GlobalKey<FormState>();
  UsersModel? users;
  /* =====================
      INIT
  ====================== */
  Future<void> _init() async {
    users = await Pref().getUsers();
    await getUsers();
  }

  TextEditingController rekening = TextEditingController();
  TextEditingController cif = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController tglLahir = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController noidentitas = TextEditingController();

  DateTime? tglKontraks = DateTime.now();
  Future gantitglkontrak() async {
    var pickedendDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    ));
    tglKontraks = pickedendDate!;
    tglLahir.text = DateFormat('dd MMM y').format(tglKontraks!);
    notifyListeners();
  }

  tutup() {
    resetform();
    tambah = false;
    notifyListeners();
  }

  resetform() async {
    rekening.clear();
    cif.clear();
    nama.clear();
    tglLahir.clear();
    phone.clear();
    notifyListeners();
  }

  void cek() async {
    if (!keyForm.currentState!.validate()) return;

    // pastikan inquiry sudah sukses
    if (cif.text.isEmpty || nama.text.isEmpty) {
      informationDialog(
        context,
        "warning",
        "Silakan cari rekening terlebih dahulu",
      );
      return;
    }

    DialogCustom().showLoading(context);

    try {
      final body = {
        "token": token.toString(),
        "bpr_id": users!.bprId.toString(),
        "kd_kantor": kdKantor,
        "no_cif": cif.text.trim(),
        "username": "", // login CMS
        "password": "", // optional / kosong
        "nama": nama.text.trim(),
        "phone": phone.text.trim(),
        "tgl_lahir": DateFormat('yyyy-MM-dd').format(tglKontraks!),
        "no_identitas": noidentitas.text.trim(),
      };

      debugPrint("CREATE USERS INFO => $body");

      final res = await AuthRepository.createUsersInfo(
        NetworkURL.usersinfocreate(),
        body,
      );

      Navigator.pop(context); // close loading

      if (res['value'] == 1) {
        tutup();
        getUsers();
        informationDialog(
          context,
          "information",
          res['message'] ?? "Berhasil disimpan",
        );
      } else {
        informationDialog(
          context,
          "error",
          res['message'] ?? "Gagal menyimpan data",
        );
      }
    } catch (e) {
      Navigator.pop(context);
      informationDialog(context, "error", e.toString());
    }
  }

  bool isInquiry = false;
String? kdKantor;
  Future<void> inquiryRekening() async {
    if (rekening.text.isEmpty || isInquiry) return;

    isInquiry = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final tgl = DateFormat('yyMMddHHmmss').format(now);

      final Map<String, dynamic> payload = {
        "token": token.toString(),
        "userlogin": users?.usersId?.toString() ?? "",
        "bpr_id": users?.bprId?.toString() ?? "",
        "trx_code": "0200",
        "trx_type": "TRX",
        "tgl_trans": tgl,
        "tgl_transmis": tgl,
        "rrn": now.millisecondsSinceEpoch.toString().substring(5),
        "no_rek": rekening.text.trim(),
        "gl_jns": "2"
      };

      /// 🔎 DEBUG PENTING
      debugPrint("INQUIRY PAYLOAD => $payload");

      final res = await AuthRepository.postJson(
        NetworkURL.inqueryRek(),
        payload,
      );

      if (res['value'] == 1) {
        cif.text = res['data']['nocif']?.toString() ?? '';
        nama.text = res['data']['nama']?.toString() ?? '';
        kdKantor = res['data']['kode_kantor']?.toString() ?? '';
      } else {
        resetRekening();
        informationDialog(
          context,
          "warning",
          res['message'] ?? "Rekening tidak ditemukan",
        );
      }
    } catch (e) {
      resetRekening();
      informationDialog(context, "error", e.toString());
    }

    isInquiry = false;
    notifyListeners();
  }

  void resetRekening() {
    cif.clear();
    nama.clear();
  }

  var tambah = false;
  tambahData() {
    tambah = true;
    notifyListeners();
  }

  /* =====================
      FETCH DATA
  ====================== */
  Future<void> getUsers() async {
    isLoading = true;
    notifyListeners();

    final offset = (page - 1) * limit;

    final res = await AuthRepository.getUsersInfoList(
      token,
      NetworkURL.getListMobileInfo(),
      bprId,
      search: cariCtrl.text.isEmpty ? null : cariCtrl.text,
      limit: limit.toString(),
      page: offset.toString(), // BACKEND PAKAI OFFSET
    );

    list = List<Map<String, dynamic>>.from(res['users_info'] ?? []);
    total = res['pagination']['total_data'] ?? 0;

    dataSource.setRows(list);
    isLoading = false;
    notifyListeners();
  }

  /* =====================
      SEARCH
  ====================== */
  void cariSekarang() {
    page = 1;
    getUsers();
  }

  void clearCari() {
    cariCtrl.clear();
    page = 1;
    getUsers();
  }

  /* =====================
      PAGINATION
  ====================== */
  void nextPage() {
    if (page < totalPages) {
      page++;
      getUsers();
    }
  }

  void prevPage() {
    if (page > 1) {
      page--;
      getUsers();
    }
  }

  /* =====================
      GRID COLUMNS
  ====================== */
  List<GridColumn> get columns => [
        GridColumn(columnName: 'no', width: 70, label: _Hdr('No')),
        GridColumn(
            columnName: 'created_at',
            width: 180,
            label: _Hdr('Tanggal Daftar')),
        GridColumn(columnName: 'no_cif', width: 140, label: _Hdr('CIF')),
        GridColumn(columnName: 'nama', width: 200, label: _Hdr('Nama')),
        GridColumn(columnName: 'phone', width: 160, label: _Hdr('Phone')),
        GridColumn(
          columnName: 'username',
          width: 160,
          label: _Hdr('Username'),
        ),
      ];
}

class UsersInfoDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  void setRows(List<Map<String, dynamic>> items) {
    int no = 1;
    _rows = items.map((m) {
      String v(String k) => m[k]?.toString() ?? '';
      return DataGridRow(
        cells: [
          DataGridCell(columnName: 'no', value: no++),
          DataGridCell(columnName: 'created_at', value: v('created_at')),
          DataGridCell(columnName: 'no_cif', value: v('no_cif')),
          DataGridCell(columnName: 'nama', value: v('nama')),
          DataGridCell(columnName: 'phone', value: v('phone')),
          DataGridCell(columnName: 'username', value: v('username')),
        ],
      );
    }).toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Widget cell(String name) {
      final v = row
          .getCells()
          .firstWhere((e) => e.columnName == name)
          .value
          .toString();
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(v, overflow: TextOverflow.ellipsis),
      );
    }

    return DataGridRowAdapter(
      cells: [
        cell('no'),
        cell('created_at'),
        cell('no_cif'),
        cell('nama'),
        cell('phone'),
        cell('username'),
      ],
    );
  }
}

class _Hdr extends StatelessWidget {
  final String text;
  final bool center;
  const _Hdr(this.text, {this.center = false});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.black,
        );
    return Container(
      alignment: center ? Alignment.center : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(text, style: t),
    );
  }
}
