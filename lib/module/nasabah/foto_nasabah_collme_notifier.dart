import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/models/nsaabah_model.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/nasabah_repository.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';
import '../../repository/auth_repository.dart';
import '../../utils/button_custom.dart';

class FotoNasabahCollmeNotifier extends ChangeNotifier {
  final BuildContext context;

  FotoNasabahCollmeNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getFotoNasabah();
      notifyListeners();
    });
  }

  var isLoading = true;
  int limit = 20;
  int offset = 0;
  List<FotoNasabahCollmeModel> list = [];
  Future getFotoNasabah() async {
    list.clear();
    isLoading = true;
    notifyListeners();
    NasabahRepository.getFotoNasabah(token, NetworkURL.getFotoNasabah(), users!.bprId, limit, offset).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['foto']) {
          list.add(FotoNasabahCollmeModel.fromJson(i));
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
  FotoNasabahCollmeModel? fotoNasabahCollmeModel;
  edit(int value) {
    fotoNasabahCollmeModel = list.where((e) => e.id == value).first;
    key.currentState!.openEndDrawer();
    notifyListeners();
  }

  TextEditingController alasan = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  tolak() async {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              child: Form(
                key: keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Konfirmasi",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Anda mekakukan penolakan pada update identitas ini?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("Alasan Penolakan"),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: alasan,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Wajib diisi";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(),
                    ),
                    SizedBox(
                      height: 24,
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
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: ButtonPrimary(
                          onTap: () {
                            Navigator.pop(context);
                            cekTolak();
                          },
                          name: "Yes",
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  cekTolak() {
    DialogCustom().showLoading(context);
    NasabahRepository.rejectedFotoCollme(token, NetworkURL.updateFotoNasabahCollme(), fotoNasabahCollmeModel!.id.toString(), alasan.text.trim())
        .then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        getFotoNasabah();
        fotoNasabahCollmeModel = null;
        alasan.clear();
        notifyListeners();
        informationDialog(context, "Information", value['message']);
      } else {
        informationDialog(context, "Information", value['message']);
      }
    });
  }

  terima() async {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              child: Form(
                key: keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Konfirmasi",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Anda mekakukan foto ini sudah sesuai dengan spesifikasi nasabah?",
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
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: ButtonPrimary(
                          onTap: () {
                            Navigator.pop(context);
                            cekTerima();
                          },
                          name: "Yes",
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  NsaabahModel? nasabahModel;
  cekTerima() {
    if (keyForm.currentState!.validate()) {
      DialogCustom().showLoading(context);
      NasabahRepository.approveFotoCollme(token, NetworkURL.approveFotoCollme(), fotoNasabahCollmeModel!.id.toString()).then((value) {
        if (value['value'] == 1) {
          AuthRepository.inqueryHp(
            token,
            NetworkURL.inqueryHp(),
            users!.bprId,
            fotoNasabahCollmeModel!.phone,
            users!.usersId,
          ).then((e) {
            if (e['value'] == 1) {
              nasabahModel = NsaabahModel.fromJson(e['data']);
              NasabahRepository.updateAkunCMS(
                token,
                NetworkURL.updateAkunCms(),
                users!.usersId,
                nasabahModel!.bprId,
                nasabahModel!.kdKantor,
                nasabahModel!.acctType,
                nasabahModel!.gender,
                nasabahModel!.tglLahir,
                nasabahModel!.noHp,
                nasabahModel!.namaRek,
                nasabahModel!.noRek,
                nasabahModel!.nama,
                nasabahModel!.noKtp,
                fotoNasabahCollmeModel!.ktp,
                fotoNasabahCollmeModel!.selfiKtp,
                nasabahModel!.noHp,
                nasabahModel!.noRek,
              ).then((values) {
                Navigator.pop(context);

                if (values['value'] == 1) {
                  nasabahModel = null;
                  fotoNasabahCollmeModel = null;
                  Future.delayed(Duration(milliseconds: 300)).then((a) {
                    getFotoNasabah();
                  });
                  notifyListeners();
                  informationDialog(context, "Informasi", values['message']);
                } else {
                  informationDialog(context, "Informasi", values['message']);
                }
              });
            } else {}
          });
          notifyListeners();
        } else {
          informationDialog(context, "Warning", value['message']);
        }
      });
    }
  }

  var last = false;
  var isLoadingMore = false;
  getMore() async {
    if (last) {
    } else {
      isLoadingMore = true;
      NasabahRepository.getFotoNasabah(token, NetworkURL.getFotoNasabah(), users!.bprId, limit, list.length).then((value) {
        if (value['value'] == 1) {
          for (Map<String, dynamic> i in value['foto']) {
            list.add(FotoNasabahCollmeModel.fromJson(i));
          }
          if (value['foto'].length < limit) {
            last = true;
          } else {
            last = false;
          }

          isLoadingMore = false;
          notifyListeners();
        } else {
          isLoadingMore = false;
          notifyListeners();
        }
      });
    }
  }
}
