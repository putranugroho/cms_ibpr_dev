import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/users_access_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:cms_ibpr/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../network/network.dart';

class UsersAccessNotifier extends ChangeNotifier {
  final BuildContext context;

  UsersAccessNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;

  String? kantorError;
  String? fasilitasError;

  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getFasilitas();
      getUsersAccess();
      notifyListeners();
    });
  }

  var isLoadingFasilitas = true;
  List<FasilitasModel> listFasilitas = [];
  List<FasilitasModel> listAddFasilitas = [];
  List<KantorModel> listKantor = [];
  KantorModel? kantorModel;

  final TextEditingController employeeSearch = TextEditingController();
  final List<EmployeeModel> employeeResults = [];
  EmployeeModel? selectedEmployee;
  bool employeeVerified = false;
  bool isSearchingEmployee = false;
  String? employeeSearchError;

  pilihKantor(KantorModel value) {
    kantorModel = value;
    kantorError = null;
    notifyListeners();
  }

  Future<void> inquiryEmployee() async {
    final search = employeeSearch.text.trim();
    employeeSearchError = null;
    employeeResults.clear();

    if (search.isEmpty) {
      employeeSearchError = "Masukkan nama, nomor employee, NIK, atau telepon";
      notifyListeners();
      return;
    }

    isSearchingEmployee = true;
    notifyListeners();

    try {
      final response = await UsersAccessRepository.inquiryEmployee(
        NetworkURL.inquiryEmployeeHRIS(),
        users!.bprId,
        search,
      );

      if (response['value'] == 1) {
        for (final item in (response['data'] ?? [])) {
          employeeResults.add(
            EmployeeModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }

        if (employeeResults.isEmpty) {
          employeeSearchError = "Employee tidak ditemukan di HRIS";
        }
      } else {
        employeeSearchError = (response['message'] ?? '').toString().trim();
        if (employeeSearchError!.isEmpty) {
          employeeSearchError = "Inquiry employee HRIS gagal";
        }
      }
    } catch (e) {
      employeeSearchError = "Inquiry employee HRIS gagal: $e";
    } finally {
      isSearchingEmployee = false;
      notifyListeners();
    }
  }

  void selectEmployee(EmployeeModel employee) {
    selectedEmployee = employee;
    employeeVerified = true;
    employeeSearchError = null;
    namaUsers.text = employee.name;

    // User ID sengaja tidak diambil dari employee_no. User tetap mengisinya.
    username.clear();

    final officeMatch = listKantor.where(
      (office) =>
          (office.kdKantor ?? '').toString().trim() ==
          employee.officeCode.trim(),
    );

    if (officeMatch.isNotEmpty) {
      kantorModel = officeMatch.first;
    } else if (employee.officeCode.isNotEmpty) {
      final employeeOffice = KantorModel(
        bpr_id: users?.bprId ?? '',
        kdKantor: employee.officeCode,
        namaKantor: employee.officeName,
        id: employee.officeId,
        branchType: employee.officeType,
      );
      listKantor.add(employeeOffice);
      kantorModel = employeeOffice;
    } else {
      kantorModel = null;
    }

    kantorError = kantorModel == null ? "Kantor employee tidak tersedia" : null;
    notifyListeners();
  }

  void changeEmployee() {
    employeeVerified = false;
    selectedEmployee = null;
    namaUsers.clear();
    username.clear();
    password.clear();
    tglKadaluarsa.clear();
    kantorModel = null;
    kantorError = null;
    fasilitasError = null;
    listAddFasilitas.clear();
    notifyListeners();
  }

  addFasilitas(FasilitasModel value) {
    if (listAddFasilitas.isEmpty) {
      listAddFasilitas.add(value);
    } else {
      if (listAddFasilitas.where((element) => element == value).isNotEmpty) {
        listAddFasilitas.remove(value);
      } else {
        listAddFasilitas.add(value);
      }
    }

    if (listAddFasilitas.isNotEmpty) {
      fasilitasError = null;
    }
    notifyListeners();
  }

  Future getFasilitas() async {
    isLoadingFasilitas = true;
    listFasilitas.clear();
    listKantor.clear();
    UsersAccessRepository.getListFasilitas(
      token,
      NetworkURL.getListFasilitas(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          listFasilitas.add(FasilitasModel.fromJson(i));
        }

        for (Map<String, dynamic> i in value['kantor']) {
          listKantor.add(KantorModel.fromJson(i));
        }
        isLoadingFasilitas = false;
        notifyListeners();
      } else {
        isLoadingFasilitas = false;
        notifyListeners();
      }
    });
  }

  var obscure = true;

  gantiobscure() {
    obscure = !obscure;
    notifyListeners();
  }

  var isLoading = true;
  List<UsersAccessModel> list = [];

  Future getUsersAccess() async {
    isLoading = true;
    list.clear();
    notifyListeners();
    UsersAccessRepository.getUsersAccess(
      token,
      NetworkURL.getUsersAccess(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(UsersAccessModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final keyForm = GlobalKey<FormState>();
  var editData = false;

  bool validateUsersAccessForm() {
    kantorError = null;
    fasilitasError = null;

    final formValid = keyForm.currentState?.validate() ?? false;

    if (kantorModel == null) {
      kantorError = "Pilih kantor";
    }

    if (!editData && selectedEmployee == null) {
      employeeSearchError = "Employee harus dipilih dari hasil inquiry HRIS";
    }

    if (listAddFasilitas.isEmpty) {
      fasilitasError = "Pilih minimal 1 fasilitas";
    }

    notifyListeners();

    return formValid &&
        kantorError == null &&
        fasilitasError == null &&
        (editData || selectedEmployee != null);
  }

  cek() {
    final valid = validateUsersAccessForm();
    if (!valid) return;

    if (editData) {
      List<FasilitasAddModel> listModel = [];
      for (var i = 0; i < listAddFasilitas.length; i++) {
        listModel.add(
          FasilitasAddModel(
            modul: listAddFasilitas[i].modul,
            menu: listAddFasilitas[i].menu,
            submenu: listAddFasilitas[i].submenu,
            subsubmenu: listAddFasilitas[i].subsubmenu,
            urut: listAddFasilitas[i].urut,
            flag: "true",
          ),
        );
      }
      Navigator.pop(context);
      DialogCustom().showLoading(context);
      UsersAccessRepository.insertUsersId(
        token,
        NetworkURL.updateUsersId(),
        "update",
        users!.bprId,
        users!.usersId,
        password.text,
        username.text.trim(),
        namaUsers.text.trim(),
        kantorModel!.kdKantor,
        tglKadaluarsa.text.trim(),
        "0",
        jsonEncode(listModel),
      ).then((value) {
        Navigator.pop(context);
        if (value['value'] == 1) {
          getUsersAccess();
          informationDialog(context, "Informasi", value['message']);
        } else {
          informationDialog(context, "Informasi", value['message']);
        }
      });
    } else {
      List<FasilitasAddModel> listModel = [];
      for (var i = 0; i < listAddFasilitas.length; i++) {
        listModel.add(
          FasilitasAddModel(
            modul: listAddFasilitas[i].modul,
            menu: listAddFasilitas[i].menu,
            submenu: listAddFasilitas[i].submenu,
            subsubmenu: listAddFasilitas[i].subsubmenu,
            urut: listAddFasilitas[i].urut,
            flag: "true",
          ),
        );
      }
      Navigator.pop(context);
      DialogCustom().showLoading(context);
      UsersAccessRepository.insertUsersId(
        token,
        NetworkURL.insertUsersId(),
        "insert",
        users!.bprId,
        users!.usersId,
        password.text,
        username.text.trim(),
        namaUsers.text.trim(),
        kantorModel!.kdKantor,
        tglKadaluarsa.text.trim(),
        "0",
        jsonEncode(listModel),
      ).then((value) {
        Navigator.pop(context);
        if (value['value'] == 1) {
          getUsersAccess();
          informationDialog(context, "Informasi", value['message']);
        } else {
          informationDialog(context, "Informasi", value['message']);
        }
      });
    }
  }

  List<dynamic>? cellValues;
  String? classSelect;
  UsersAccessModel? usersAccessModel;

  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      usersAccessModel = list.where((element) => element.userid == cellValues![2]).first;
      checkFasilitas();
      notifyListeners();
    }
  }

  List<FasilitasAddModel> listModelUsers = [];

  Future checkFasilitas() async {
    listModelUsers.clear();
    DialogCustom().showLoading(context);
    UsersAccessRepository.getListFasilitasByUsers(
      token,
      NetworkURL.getListFasilitasByUsers(),
      users!.usersId,
      usersAccessModel!.userid,
      users!.bprId,
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          listModelUsers.add(FasilitasAddModel.fromJson(i));
        }
        edit();
      } else {
        edit();
      }
    });
  }

  gantiTanggal() async {
    var pickedendDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2090),
    );

    if (pickedendDate != null) {
      tglKadaluarsa.text = DateFormat("yyyy-MM-dd").format(pickedendDate);
      notifyListeners();
    }
  }

  TextEditingController namaUsers = TextEditingController();
  TextEditingController tglKadaluarsa = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  tambah() {
    namaUsers.clear();
    tglKadaluarsa.clear();
    username.clear();
    password.clear();
    kantorModel = null;
    kantorError = null;
    fasilitasError = null;
    listAddFasilitas.clear();
    editData = false;
    employeeSearch.clear();
    employeeResults.clear();
    selectedEmployee = null;
    employeeVerified = false;
    employeeSearchError = null;
    key.currentState!.openEndDrawer();
    notifyListeners();
  }

  edit() {
    key.currentState!.openEndDrawer();
    editData = true;
    listAddFasilitas.clear();
    kantorError = null;
    fasilitasError = null;
    employeeVerified = false;
    selectedEmployee = null;
    employeeSearchError = null;

    final selected = listModelUsers.where(
      (e) => (e.flag ?? "").toUpperCase() == "TRUE",
    );

    for (final item in selected) {
      listAddFasilitas.add(
        FasilitasModel(
          modul: item.modul,
          menu: item.menu,
          submenu: item.submenu,
          subsubmenu: item.subsubmenu,
          urut: item.urut,
        ),
      );
    }

    namaUsers.text = usersAccessModel?.namauser ?? "";
    tglKadaluarsa.text = usersAccessModel?.tglexp ?? "";
    username.text = usersAccessModel?.userid ?? "";
    password.text = decryptString(usersAccessModel?.pass ?? "");

    final kantorMatch = listKantor.where(
      (element) => (element.kdKantor ?? "").toString().trim() == (usersAccessModel?.kdkantor ?? "").toString().trim(),
    );

    kantorModel = kantorMatch.isNotEmpty ? kantorMatch.first : null;

    notifyListeners();
  }

  Future<void> hapusUsersAccess() async {
    if (usersAccessModel == null) {
      informationDialog(context, "Informasi", "Pilih user terlebih dahulu");
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text(
          "Hapus user ${usersAccessModel?.userid ?? '-'}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    List<FasilitasAddModel> listModel = [];

    final sourceFasilitas = listModelUsers.isNotEmpty
        ? listModelUsers
        : listAddFasilitas
            .map(
              (e) => FasilitasAddModel(
                modul: e.modul,
                menu: e.menu,
                submenu: e.submenu,
                subsubmenu: e.subsubmenu,
                urut: e.urut,
                flag: "true",
              ),
            )
            .toList();

    for (final item in sourceFasilitas) {
      listModel.add(
        FasilitasAddModel(
          modul: item.modul,
          menu: item.menu,
          submenu: item.submenu,
          subsubmenu: item.subsubmenu,
          urut: item.urut,
          flag: item.flag ?? "false",
        ),
      );
    }

    Navigator.pop(context);
    DialogCustom().showLoading(context);

    UsersAccessRepository.deleteUsersId(
      token,
      NetworkURL.deleteUsersId(),
      users!.bprId,
      users!.usersId,
      usersAccessModel?.userid ?? username.text.trim(),
      password.text,
      namaUsers.text.trim(),
      kantorModel?.kdKantor ?? usersAccessModel?.kdkantor ?? "",
      tglKadaluarsa.text.trim(),
      "0",
      jsonEncode(listModel),
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        getUsersAccess();
        tambah();
        informationDialog(context, "Informasi", value['message']);
      } else {
        informationDialog(context, "Informasi", value['message']);
      }
    });
  }

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmText,
    Color confirmColor = Colors.blue,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(color: confirmColor),
            ),
          ),
        ],
      ),
    );

    return confirm == true;
  }

  Future<void> forceLogoutSelectedUser() async {
    if (usersAccessModel == null) {
      informationDialog(context, "Informasi", "Pilih user terlebih dahulu");
      return;
    }

    final targetUserId = (usersAccessModel?.userid ?? username.text).trim();
    if (targetUserId.isEmpty) {
      informationDialog(context, "Informasi", "User ID tidak valid");
      return;
    }

    final confirm = await _confirmAction(
      title: "Konfirmasi",
      message: "Paksa logout user $targetUserId?",
      confirmText: "Logout",
      confirmColor: Colors.orange,
    );

    if (!confirm) return;

    Navigator.pop(context);
    DialogCustom().showLoading(context);

    UsersAccessRepository.forceLogoutUser(
      NetworkURL.logout(),
      users!.bprId,
      users!.usersId,
      targetUserId,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        getUsersAccess();
      }

      informationDialog(context, "Informasi", value['message']);
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Informasi", e.toString());
    });
  }

  Future<void> unblockSelectedUser() async {
    if (usersAccessModel == null) {
      informationDialog(context, "Informasi", "Pilih user terlebih dahulu");
      return;
    }

    final targetUserId = (usersAccessModel?.userid ?? username.text).trim();
    if (targetUserId.isEmpty) {
      informationDialog(context, "Informasi", "User ID tidak valid");
      return;
    }

    final confirm = await _confirmAction(
      title: "Konfirmasi",
      message: "Buka blokir user $targetUserId?",
      confirmText: "Buka Blokir",
      confirmColor: Colors.green,
    );

    if (!confirm) return;

    Navigator.pop(context);
    DialogCustom().showLoading(context);

    UsersAccessRepository.unblockUserId(
      NetworkURL.unblokirUserId(),
      users!.bprId,
      users!.usersId,
      targetUserId,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        getUsersAccess();
      }

      informationDialog(context, "Informasi", value['message']);
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Informasi", e.toString());
    });
  }

  Future<void> resetDeviceSelectedUser() async {
    if (usersAccessModel == null) {
      informationDialog(context, "Informasi", "Pilih user terlebih dahulu");
      return;
    }

    final targetUserId = (usersAccessModel?.userid ?? username.text).trim();
    if (targetUserId.isEmpty) {
      informationDialog(context, "Informasi", "User ID tidak valid");
      return;
    }

    final confirm = await _confirmAction(
      title: "Konfirmasi",
      message: "Reset perangkat yang terhubung dengan user $targetUserId?",
      confirmText: "Reset Device",
      confirmColor: Colors.blue,
    );

    if (!confirm) return;

    Navigator.pop(context);
    DialogCustom().showLoading(context);

    UsersAccessRepository.resetDeviceUserId(
      NetworkURL.resetDeviceUserId(),
      users!.bprId,
      users!.usersId,
      targetUserId,
    ).then((value) {
      Navigator.pop(context);

      if (value['value'] == 1) {
        getUsersAccess();
      }

      informationDialog(context, "Informasi", value['message']);
    }).catchError((e) {
      Navigator.pop(context);
      informationDialog(context, "Informasi", e.toString());
    });
  }

  @override
  void dispose() {
    employeeSearch.dispose();
    namaUsers.dispose();
    tglKadaluarsa.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }
}
