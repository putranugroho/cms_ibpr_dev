import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/acct_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../../utils/button_custom.dart';

class AccountTypeNotifier extends ChangeNotifier {
  final BuildContext context;

  AccountTypeNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getAccountType();
      notifyListeners();
    });
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final keyForm = GlobalKey<FormState>();
  var isLoading = true;
  List<AcctTypeModel> list = [];
  Future getAccountType() async {
    list.clear();
    isLoading = true;
    notifyListeners();
    AccountRepository.getListAll(
      token,
      NetworkURL.getListAcctType(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(AcctTypeModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  TextEditingController kdAcc = TextEditingController();
  TextEditingController keterangan = TextEditingController();

  List<dynamic>? cellValues;
  String? classSelect;
  AcctTypeModel? acctTypeModel;
  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    // Cetak informasi tentang data yang dipilih
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      // var kategoriNew = cellValues![2];
      // phoneSelect = cellValues![6];
      acctTypeModel =
          list.where((element) => element.kdAcc == cellValues![1]).first;
      print("${cellValues![1]}");
      edit();
      notifyListeners();
      // transaksiModel =
      //     list.where((element) => element.invoice == cellValues![7]).first;
      // notifyListeners();
      // print(selectedData);
    }
  }

  var editdata = false;
  tambah() {
    key.currentState!.openEndDrawer();
    editdata = false;
    kdAcc.clear();
    keterangan.clear();
    notifyListeners();
  }

  edit() {
    key.currentState!.openEndDrawer();
    editdata = true;
    kdAcc.text = acctTypeModel!.kdAcc;
    keterangan.text = acctTypeModel!.keterangan;
    notifyListeners();
  }

  cek() {
    if (keyForm.currentState!.validate()) {
      if (editdata) {
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        AccountRepository.insertAcctTYpe(
                token,
                NetworkURL.updateAcctTYpe(),
                users!.bprId,
                users!.usersId,
                kdAcc.text.trim(),
                keterangan.text.trim())
            .then((value) {
          Navigator.pop(context);
          if (value['value'] == 1) {
            getAccountType();
            informationDialog(context, "Informasi", value['message']);
          } else {
            informationDialog(context, "Informasi", value['message']);
          }
        });
      } else {
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        AccountRepository.insertAcctTYpe(
                token,
                NetworkURL.insertAcctTYpe(),
                users!.bprId,
                users!.usersId,
                kdAcc.text.trim(),
                keterangan.text.trim())
            .then((value) {
          Navigator.pop(context);
          if (value['value'] == 1) {
            getAccountType();
            informationDialog(context, "Informasi", value['message']);
          } else {
            informationDialog(context, "Informasi", value['message']);
          }
        });
      }
    }
  }

  confirm() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Konfirmasi Hapus",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Anda yakin akan menghapus ${acctTypeModel!.keterangan}?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ButtonSecondary(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        name: "No",
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: ButtonPrimary(
                        onTap: () {
                          Navigator.pop(context);
                          delete();
                        },
                        name: "Yes",
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  delete() async {
    DialogCustom().showLoading(context);
    AccountRepository.insertAcctTYpe(
            token,
            NetworkURL.deleteAcctTYpe(),
            users!.bprId,
            users!.usersId,
            kdAcc.text.trim(),
            keterangan.text.trim())
        .then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        getAccountType();
        informationDialog(context, "Information", value['message']);
      } else {
        informationDialog(context, "Error", value['message']);
      }
    });
  }
}
