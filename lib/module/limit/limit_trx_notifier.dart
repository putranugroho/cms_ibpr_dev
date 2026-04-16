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
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();

      limitHarianModel = list.where((element) => element.acctType == cellValues![1]).first;

      edit();
      notifyListeners();
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
    trkTunai.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.trkTunaiTrx ?? "0") ?? 0).replaceAll(".", ",");
    setorTunai.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.setorTrx ?? "0") ?? 0).replaceAll(".", ",");
    transfer.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.trfTrx ?? "0") ?? 0).replaceAll(".", ",");
    ppob.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.ppobTrx ?? "0") ?? 0).replaceAll(".", ",");
    qr.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.qrTrx ?? "0") ?? 0).replaceAll(".", ",");
    kdAcc.text = limitHarianModel?.acctType ?? "";
    desc.text = limitHarianModel?.description ?? "";
    notifyListeners();
  }

  final keyForm = GlobalKey<FormState>();

  cek() {
    if (keyForm.currentState!.validate()) {
      Navigator.pop(context);
      DialogCustom().showLoading(context);

      final List<LimitTrxModel> listResult = list.where((element) => element != limitHarianModel).toList();

      listResult.add(
        LimitTrxModel(
          acctType: kdAcc.text,
          description: limitHarianModel?.description ?? "",
          trfTrx: transfer.text.replaceAll(",", ""),
          setorTrx: setorTunai.text.replaceAll(",", ""),
          trkTunaiTrx: trkTunai.text.replaceAll(",", ""),
          qrTrx: qr.text.replaceAll(",", ""),
          ppobTrx: ppob.text.replaceAll(",", ""),
        ),
      );

      LimitRepository.insertLimitTrx(
        token,
        NetworkURL.insertLimitTrx(),
        users!.bprId,
        users!.usersId,
        jsonEncode(listResult),
      ).then((value) {
        Navigator.pop(context);
        if (value['value'] == 1) {
          getLimitHarian();
          informationDialog(context, "Informasi", value['message']);
        } else {
          informationDialog(context, "Informasi", value['message']);
        }
      }).catchError((e) {
        Navigator.pop(context);
        informationDialog(context, "Error", e.toString());
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
        for (final raw in value['data']) {
          final i = Map<String, dynamic>.from(raw);

          list.add(
            LimitTrxModel(
              acctType: (i['acctType'] ?? i['acct_type'] ?? "").toString(),
              description: (i['description'] ?? "").toString(),
              trkTunaiTrx: (i['trkTunaiTrx'] ?? i['tarik_tunai'] ?? 0).toString(),
              setorTrx: (i['setorTrx'] ?? i['setor'] ?? 0).toString(),
              trfTrx: (i['trfTrx'] ?? i['transfer'] ?? 0).toString(),
              qrTrx: (i['qrTrx'] ?? i['qr'] ?? 0).toString(),
              ppobTrx: (i['ppobTrx'] ?? i['ppob'] ?? 0).toString(),
            ),
          );
        }

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
}
