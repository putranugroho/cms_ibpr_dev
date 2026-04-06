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
  pilihKantor(KantorModel value) {
    kantorModel = value;
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
    notifyListeners();
  }

  Future getFasilitas() async {
    isLoadingFasilitas = true;
    listFasilitas.clear();
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

  cek() {
    if (keyForm.currentState!.validate()) {
      if (editData) {
        List<FasilitasAddModel> listModel = [];
        for (var i = 0; i < listAddFasilitas.length; i++) {
          listModel.add(FasilitasAddModel(
              modul: listAddFasilitas[i].modul,
              menu: listAddFasilitas[i].menu,
              submenu: listAddFasilitas[i].submenu,
              subsubmenu: listAddFasilitas[i].subsubmenu,
              urut: listAddFasilitas[i].urut,
              flag: "true"));
        }
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        UsersAccessRepository.insertUsersId(token, NetworkURL.updateUsersId(), "update", users!.bprId, users!.usersId, password.text,
                username.text.trim(), namaUsers.text.trim(), kantorModel!.kdKantor, tglKadaluarsa.text.trim(), "0", jsonEncode(listModel))
            .then((value) {
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
          listModel.add(FasilitasAddModel(
              modul: listAddFasilitas[i].modul,
              menu: listAddFasilitas[i].menu,
              submenu: listAddFasilitas[i].submenu,
              subsubmenu: listAddFasilitas[i].subsubmenu,
              urut: listAddFasilitas[i].urut,
              flag: "true"));
        }
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        UsersAccessRepository.insertUsersId(token, NetworkURL.insertUsersId(), "insert", users!.bprId, users!.usersId, password.text,
                username.text.trim(), namaUsers.text.trim(), kantorModel!.kdKantor, tglKadaluarsa.text.trim(), "0", jsonEncode(listModel))
            .then((value) {
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
  }

  List<dynamic>? cellValues;
  String? classSelect;
  UsersAccessModel? usersAccessModel;
  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    // Cetak informasi tentang data yang dipilih
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      // var kategoriNew = cellValues![2];
      // phoneSelect = cellValues![6];
      usersAccessModel = list.where((element) => element.userid == cellValues![2]).first;
      print("${cellValues![2]}");
      checkFasilitas();
      notifyListeners();
      // transaksiModel =
      //     list.where((element) => element.invoice == cellValues![7]).first;
      // notifyListeners();
      // print(selectedData);
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
    var pickedendDate = (await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2090)));

    tglKadaluarsa.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(pickedendDate.toString()));
    notifyListeners();
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
    listAddFasilitas.clear();
    key.currentState!.openEndDrawer();
    editData = false;
    notifyListeners();
  }

  edit() {
    key.currentState!.openEndDrawer();
    editData = true;
    listAddFasilitas.clear();

    final selected = listModelUsers.where((e) => (e.flag ?? "").toUpperCase() == "TRUE");

    for (final item in selected) {
      listAddFasilitas.add(FasilitasModel(
        modul: item.modul,
        menu: item.menu,
        submenu: item.submenu,
        subsubmenu: item.subsubmenu,
        urut: item.urut,
      ));
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
}
