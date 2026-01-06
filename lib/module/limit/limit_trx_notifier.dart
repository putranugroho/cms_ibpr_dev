import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/limit_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/format_currency.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';

class LimitTrxNotifier extends ChangeNotifier {
  final BuildContext context;

  LimitTrxNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getLimitHarian();
      notifyListeners();
    });
  }

  List<dynamic>? cellValues;
  String? classSelect;
  LimitTrxModel? limitHarianModel;
  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    // Cetak informasi tentang data yang dipilih
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      // var kategoriNew = cellValues![2];
      // phoneSelect = cellValues![6];
      print("${cellValues![1]}");
      limitHarianModel =
          list.where((element) => element.acctType == cellValues![1]).first;
      print(limitHarianModel!.acctType);
      // print(limitHarianModel!.trkTunaiHarian);
      edit();
      notifyListeners();
      // transaksiModel =
      //     list.where((element) => element.invoice == cellValues![7]).first;
      // notifyListeners();
      // print(selectedData);
    }
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  TextEditingController trkTunai = TextEditingController();
  TextEditingController setorTunai = TextEditingController();
  TextEditingController transfer = TextEditingController();
  TextEditingController ppob = TextEditingController();
  TextEditingController qr = TextEditingController();
  TextEditingController kdAcc = TextEditingController();
  TextEditingController desc = TextEditingController();
  edit() {
    key.currentState!.openEndDrawer();
    trkTunai.text = FormatCurrency.oCcy
        .format(int.parse(limitHarianModel!.trkTunaiTrx))
        .replaceAll(".", ",");
    setorTunai.text = FormatCurrency.oCcy
        .format(int.parse(limitHarianModel!.setorTrx))
        .replaceAll(".", ",");
    transfer.text = FormatCurrency.oCcy
        .format(int.parse(limitHarianModel!.trfTrx))
        .replaceAll(".", ",");
    ppob.text = FormatCurrency.oCcy
        .format(int.parse(limitHarianModel!.ppobTrx))
        .replaceAll(".", ",");
    qr.text = FormatCurrency.oCcy
        .format(int.parse(limitHarianModel!.qrTrx))
        .replaceAll(".", ",");
    kdAcc.text = limitHarianModel!.acctType;
    desc.text = limitHarianModel!.description;
    notifyListeners();
  }

  final keyForm = GlobalKey<FormState>();
  cek() {
    if (keyForm.currentState!.validate()) {
      Navigator.pop(context);
      DialogCustom().showLoading(context);
      List<LimitTrxModel> listResult = [];
      for (var i = 0;
          i < list.where((element) => element != limitHarianModel).length;
          i++) {
        final data = list[i];
        listResult.add(data);
      }
      listResult.add(LimitTrxModel(
          acctType: kdAcc.text,
          description: limitHarianModel!.description,
          trfTrx: transfer.text.replaceAll(",", ""),
          setorTrx: setorTunai.text.replaceAll(",", ""),
          trkTunaiTrx: trkTunai.text.replaceAll(",", ""),
          qrTrx: qr.text.replaceAll(",", ""),
          ppobTrx: ppob.text.replaceAll(",", "")));
      LimitRepository.insertLimitHarian(token, NetworkURL.insertLimitTrx(),
              users!.bprId, users!.usersId, jsonEncode(listResult))
          .then((value) {
        Navigator.pop(context);
        if (value['value'] == 1) {
          getLimitHarian();
          informationDialog(context, "Informasi", value['message']);
        } else {
          informationDialog(context, "Informasi", value['message']);
        }
      });
    }
  }

  var isLoading = true;
  List<LimitTrxModel> list = [];
  Future getLimitHarian() async {
    isLoading = true;
    list.clear();
    notifyListeners();
    LimitRepository.getLimitTrx(
      token,
      NetworkURL.getLimitTrx(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(LimitTrxModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
