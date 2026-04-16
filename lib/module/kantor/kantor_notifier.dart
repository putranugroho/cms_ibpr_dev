import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/kantor_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../../utils/button_custom.dart';

class KantorNotifier extends ChangeNotifier {
  final BuildContext context;

  KantorNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;

  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getKantor();
      notifyListeners();
    });
  }

  var isLoading = true;
  List<KantorModel> list = [];
  List<KantorModel> listResult = [];
  KantorModel? kantorModel;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  List<SandiBankModel> listSandi = [];
  SandiBankModel? sandiBankModel;

  pilihBank(SandiBankModel value) {
    sandiBankModel = value;
    notifyListeners();
  }

  TextEditingController namakantor = TextEditingController();
  TextEditingController kdKantor = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  var editData = false;

  cek() {
    if (keyForm.currentState!.validate()) {
      if (editData) {
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        KantorRepository.updateKantorCMS(
          token,
          NetworkURL.updateKantorCMS(),
          users!.bprId,
          users!.usersId,
          users!.bprId,
          kdKantor.text.trim(),
          namakantor.text.trim(),
        ).then((value) {
          Navigator.pop(context);
          if (value['value'] == 1) {
            getKantor();
            informationDialog(context, "Informasi", value['message']);
          } else {
            informationDialog(context, "Informasi", value['message']);
          }
        });
      } else {
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        KantorRepository.insertKantorCMS(
          token,
          NetworkURL.insertKantorCMS(),
          users!.bprId,
          users!.usersId,
          users!.bprId,
          kdKantor.text.trim(),
          namakantor.text.trim(),
        ).then((value) {
          Navigator.pop(context);
          if (value['value'] == 1) {
            getKantor();
            informationDialog(context, "Informasi", value['message']);
          } else {
            informationDialog(context, "Informasi", value['message']);
          }
        });
      }
    }
  }

  tambah() {
    key.currentState!.openEndDrawer();
    editData = false;
    namakantor.clear();
    kdKantor.clear();

    if (listSandi.isNotEmpty) {
      sandiBankModel = listSandi.first;
    }

    notifyListeners();
  }

  edit() {
    key.currentState!.openEndDrawer();
    editData = true;
    namakantor.text = kantorModel?.namaKantor ?? "";
    kdKantor.text = kantorModel?.kdKantor ?? "";

    if (listSandi.isNotEmpty) {
      try {
        sandiBankModel = listSandi.firstWhere(
          (element) => element.kodeBank == kantorModel?.bpr_id,
        );
      } catch (_) {
        sandiBankModel = listSandi.first;
      }
    } else {
      sandiBankModel = null;
    }

    notifyListeners();
  }

  List<dynamic>? cellValues;
  String? classSelect;

  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();

      kantorModel = list.where((element) {
        return element.bpr_id == cellValues![1] && element.kdKantor == cellValues![2];
      }).first;

      edit();
      notifyListeners();
    }
  }

  Future getKantor() async {
    isLoading = true;
    list.clear();
    listSandi.clear();
    notifyListeners();

    KantorRepository.getKantor(
      token,
      NetworkURL.getListKantorAccess(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(KantorModel.fromJson(i));
        }

        if (value['sandi_bank'] != null) {
          for (Map<String, dynamic> i in value['sandi_bank']) {
            listSandi.add(SandiBankModel.fromJson(i));
          }
        }

        if (listSandi.isEmpty && users != null) {
          try {
            listSandi.add(
              SandiBankModel.fromJson({
                "kode_bank": users!.bprId,
                "nama": users!.bprId,
              }),
            );
          } catch (_) {}
        }

        if (listSandi.isNotEmpty) {
          sandiBankModel = listSandi.first;
        }

        listResult = list.where((element) => element.bpr_id != null).toList();
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      informationDialog(context, "Error", e.toString());
    });
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
                  "Anda yakin akan menghapus ${kantorModel!.namaKantor}?",
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
                      ),
                    ),
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
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  delete() async {
    DialogCustom().showLoading(context);
    KantorRepository.deleteKantorCMS(
      token,
      NetworkURL.deleteKantorCMS(),
      users!.bprId,
      users!.usersId,
      users!.bprId,
      kdKantor.text.trim(),
      namakantor.text.trim(),
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        getKantor();
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
