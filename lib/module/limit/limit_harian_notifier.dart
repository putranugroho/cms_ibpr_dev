import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/limit_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/format_currency.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';

class LimitHarianNotifier extends ChangeNotifier {
  final BuildContext context;

  LimitHarianNotifier({required this.context}) {
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
  LimitHarianModel? limitHarianModel;

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
    trkTunai.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.trkTunaiHarian ?? "0") ?? 0).replaceAll(".", ",");
    setorTunai.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.setorHarian ?? "0") ?? 0).replaceAll(".", ",");
    transfer.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.trfHarian ?? "0") ?? 0).replaceAll(".", ",");
    ppob.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.ppobHarian ?? "0") ?? 0).replaceAll(".", ",");
    qr.text = FormatCurrency.oCcy.format(int.tryParse(limitHarianModel?.qrHarian ?? "0") ?? 0).replaceAll(".", ",");
    kdAcc.text = limitHarianModel?.acctType ?? "";
    desc.text = limitHarianModel?.description ?? "";
    notifyListeners();
  }

  final keyForm = GlobalKey<FormState>();

  cek() {
    if (keyForm.currentState!.validate()) {
      Navigator.pop(context);
      DialogCustom().showLoading(context);

      final List<LimitHarianModel> listResult = list.where((element) => element != limitHarianModel).toList();

      listResult.add(
        LimitHarianModel(
          acctType: kdAcc.text,
          description: limitHarianModel?.description ?? "",
          trkTunaiHarian: trkTunai.text.replaceAll(",", ""),
          setorHarian: setorTunai.text.replaceAll(",", ""),
          trfHarian: transfer.text.replaceAll(",", ""),
          qrHarian: qr.text.replaceAll(",", ""),
          ppobHarian: ppob.text.replaceAll(",", ""),
        ),
      );

      LimitRepository.insertLimitHarian(
        token,
        NetworkURL.insertLimitHarian(),
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
  List<LimitHarianModel> list = [];

  Future getLimitHarian() async {
    isLoading = true;
    list.clear();
    notifyListeners();

    LimitRepository.getLimitHarian(
      token,
      NetworkURL.getLimitHarian(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        for (final raw in value['data']) {
          final i = Map<String, dynamic>.from(raw);

          list.add(
            LimitHarianModel(
              acctType: (i['acctType'] ?? i['acct_type'] ?? "").toString(),
              description: (i['description'] ?? "").toString(),
              trkTunaiHarian: (i['trkTunaiHarian'] ?? i['tarik_tunai'] ?? 0).toString(),
              setorHarian: (i['setorHarian'] ?? i['setor'] ?? 0).toString(),
              trfHarian: (i['trfHarian'] ?? i['transfer'] ?? 0).toString(),
              qrHarian: (i['qrHarian'] ?? i['qr'] ?? 0).toString(),
              ppobHarian: (i['ppobHarian'] ?? i['ppob'] ?? 0).toString(),
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
