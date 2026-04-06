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
        KnatorRepository.updateKantorCMS(
                token,
                NetworkURL.updateKantorCMS(),
                users!.bprId,
                users!.usersId,
                // sandiBankModel!.kodeBank,
                users!.bprId,
                kdKantor.text.trim(),
                namakantor.text.trim())
            .then((value) {
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
        KnatorRepository.insertKantorCMS(
                token,
                NetworkURL.insertKantorCMS(),
                users!.bprId,
                users!.usersId,
                // sandiBankModel!.kodeBank,
                users!.bprId,
                kdKantor.text.trim(),
                namakantor.text.trim())
            .then((value) {
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
    notifyListeners();
  }

  edit() {
    key.currentState!.openEndDrawer();
    editData = true;
    namakantor.text = kantorModel!.namaKantor;
    kdKantor.text = kantorModel!.kdKantor;
    // print(kantorModel!.bpr_id);
    sandiBankModel = listSandi.where((element) => element.kodeBank == kantorModel!.bpr_id).first;
    notifyListeners();
  }

  List<dynamic>? cellValues;
  String? classSelect;

  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    // Cetak informasi tentang data yang dipilih
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      // var kategoriNew = cellValues![2];
      // phoneSelect = cellValues![6];
      kantorModel = list.where((element) => element.bpr_id == cellValues![1] && element.kdKantor == cellValues![2]).first;
      print("${cellValues![1]}");
      edit();
      notifyListeners();
      // transaksiModel =
      //     list.where((element) => element.invoice == cellValues![7]).first;
      // notifyListeners();
      // print(selectedData);
    }
  }

  Future getKantor() async {
    isLoading = true;
    list.clear();
    listSandi.clear();
    notifyListeners();
    KnatorRepository.getKantor(
      token,
      NetworkURL.getListKantorAccess(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(KantorModel.fromJson(i));
        }
        for (Map<String, dynamic> i in value['sandi_bank']) {
          listSandi.add(SandiBankModel.fromJson(i));
        }
        listResult = list.where((element) => element.bpr_id != null).toList();
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
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
    KnatorRepository.deleteKantorCMS(
            token, NetworkURL.deleteKantorCMS(), users!.bprId, users!.usersId, sandiBankModel!.kodeBank, kdKantor.text.trim(), namakantor.text.trim())
        .then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        getKantor();
        informationDialog(context, "Information", value['message']);
      } else {
        informationDialog(context, "Error", value['message']);
      }
    });
  }
}
