import 'dart:convert';

import 'package:cms_ibpr/main.dart';
import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/acct_repository.dart';
import 'package:cms_ibpr/repository/nasabah_repository.dart';
import 'package:cms_ibpr/utils/dialog_custom.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import '../../network/network.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

import '../../utils/button_custom.dart';

class NasabahNotifier extends ChangeNotifier {
  final BuildContext context;

  NasabahNotifier({required this.context}) {
    getProfile();
  }

  img.Image? selfi;
  img.Image? ktp;

  UsersModel? users;
  int? selectCamera;
  var ketemuCamera = false;
  CameraController? controller;
  CameraController? controller2;

  String? genderError;
  String? acctTypeError;
  String? rekeningError;

  getProfile() async {
    cameras = await availableCameras();
    notifyListeners();
    Pref().getUsers().then((value) {
      users = value;
      getAccountType();
      getNasabah();
      notifyListeners();
      if (cameras.isNotEmpty) {
        ketemuCamera = true;
        notifyListeners();
        if (selectCamera == null) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 500,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text("Pilih Kamera Anda"),
                      const SizedBox(height: 6),
                      ListView.builder(
                        itemCount: cameras.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  selectCamera = i;
                                  controller = CameraController(
                                    cameras[selectCamera!],
                                    ResolutionPreset.max,
                                  );
                                  controller2 = CameraController(
                                    cameras[selectCamera!],
                                    ResolutionPreset.max,
                                  );
                                  notifyListeners();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(cameras[i].name),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          ketemuCamera = false;
          notifyListeners();
        }
      } else {
        ketemuCamera = false;
        notifyListeners();
      }
    });
  }

  var isLoadingAccount = true;
  List<AcctTypeModel> listAccount = [];
  AcctTypeModel? acctTypeModel;

  pilihAcctType(AcctTypeModel value) {
    acctTypeModel = value;
    acctTypeError = null;
    notifyListeners();
  }

  TextEditingController namaLengkap = TextEditingController();
  TextEditingController noHp = TextEditingController();
  TextEditingController nik = TextEditingController();
  TextEditingController norek = TextEditingController();
  TextEditingController namarek = TextEditingController();
  TextEditingController tglLahir = TextEditingController();

  String? gender = "l";

  pilihGender(String value) {
    gender = value;
    genderError = null;
    notifyListeners();
  }

  gantiTanggal() async {
    var pickedendDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (pickedendDate != null) {
      tglLahir.text = DateFormat("yyyy-MM-dd").format(pickedendDate);
      notifyListeners();
    }
  }

  List<KantorModel> listKantor = [];
  KantorModel? kantorModel;

  pilihKantor(KantorModel value) {
    kantorModel = value;
    notifyListeners();
  }

  final keyForm = GlobalKey<FormState>();

  bool validateStepDataDiri() {
    genderError = null;
    acctTypeError = null;
    rekeningError = null;

    final formValid = keyForm.currentState?.validate() ?? false;

    if (namarek.text.trim().isEmpty) {
      rekeningError = "Silakan tampilkan rekening terlebih dahulu";
    }

    if (gender == null || gender!.trim().isEmpty) {
      genderError = "Pilih jenis kelamin";
    }

    if (acctTypeModel == null) {
      acctTypeError = "Pilih account type";
    }

    notifyListeners();

    return formValid && rekeningError == null && genderError == null && acctTypeError == null;
  }

  getAccountType() async {
    isLoadingAccount = true;
    list.clear();
    listKantor.clear();
    notifyListeners();
    AccountRepository.getListAll(
      token,
      NetworkURL.getListAcctType(),
      users!.usersId,
      users!.bprId,
    ).then((value) {
      if (value['value'] == 1) {
        listAccount.clear();
        for (Map<String, dynamic> i in value['data']) {
          listAccount.add(AcctTypeModel.fromJson(i));
        }
        for (Map<String, dynamic> i in value['kantor']) {
          listKantor.add(KantorModel.fromJson(i));
        }
        isLoadingAccount = false;
        notifyListeners();
      } else {
        isLoadingAccount = false;
        notifyListeners();
      }
    });
  }

  XFile? image;
  XFile? image2;

  close() {
    Navigator.pop(context);
    controller!.dispose();
    controller2!.dispose();
    notifyListeners();
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  tambah() {
    nasabahModel = null;
    kantorModel = null;
    acctTypeModel = null;
    gender = null;
    genderError = null;
    acctTypeError = null;
    rekeningError = null;
    tglLahir.clear();
    noHp.clear();
    namarek.clear();
    norek.clear();
    namaLengkap.clear();
    nik.clear();
    key.currentState!.openEndDrawer();
    editData = false;
    image = null;
    image2 = null;
    controller = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    controller2 = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    currentStep = 0;
    tombolcapture = false;
    tombolcaptureselfie = false;
    notifyListeners();
  }

  bool tombolcapture = false;

  openKTP() {
    controller2!.initialize().then((_) {
      notifyListeners();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
    tombolcapture = true;
  }

  bool tombolcaptureselfie = false;

  openKTPSelfi() {
    controller!.initialize().then((_) {
      notifyListeners();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
    tombolcaptureselfie = true;
  }

  captureKTP() async {
    try {
      image2 = await controller2!.takePicture();
      notifyListeners();
    } catch (e) {}
    tombolcapture = false;
    notifyListeners();
  }

  captureSelfiKTP() async {
    try {
      image = await controller!.takePicture();
      notifyListeners();
    } catch (e) {}
    tombolcaptureselfie = false;
    notifyListeners();
  }

  inquery() async {
    if (norek.text.trim().isEmpty) {
      informationDialog(context, "Error", "No. rekening wajib diisi");
      return;
    }

    DialogCustom().showLoading(context);
    var invoice = DateTime.now().microsecondsSinceEpoch.toString();
    NasabahRepository.inqueryRekCMS(
      token,
      NetworkURL.inqueryRekCMS(),
      users!.usersId,
      users!.bprId,
      "0200",
      "TRX",
      DateFormat('yyMMddHHmmss').format(DateTime.now()),
      DateFormat('yyMMddHHmmss').format(DateTime.now()),
      invoice,
      norek.text.trim(),
      "2",
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        namarek.text = value['data']['nama'];
        rekeningError = null;
        notifyListeners();
      } else {
        informationDialog(context, "Error", value['message']);
      }
    });
  }

  cek() async {
    if (keyForm.currentState!.validate()) {
      if (editData) {
        Navigator.pop(context);
        DialogCustom().showLoading(context);
        var path;
        var imageSelfi;
        var path2;
        var imageKtp;
        if (image != null) {
          path = await image!.readAsBytes();
          imageSelfi = "_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        }
        if (image2 != null) {
          path2 = await image2!.readAsBytes();
          imageKtp = "${DateTime.now().millisecondsSinceEpoch.toString()}__.jpg";
        }

        NasabahRepository.insertGallery(
          token,
          NetworkURL.insertGallery(),
          path2,
          imageKtp,
          path,
          imageSelfi,
        ).then((value) {
          if (value['value'] == 1) {
            NasabahRepository.updateAkunCMS(
              token,
              NetworkURL.updateAkunCms(),
              users!.usersId,
              kantorModel!.bpr_id,
              kantorModel!.kdKantor,
              acctTypeModel!.kdAcc,
              gender!,
              tglLahir.text.trim(),
              noHp.text.trim(),
              namarek.text.trim(),
              norek.text.trim(),
              namaLengkap.text.trim(),
              nik.text.trim(),
              image != null ? imageKtp : nasabahModel!.fhoto1,
              image2 != null ? imageSelfi : nasabahModel!.fhoto2,
              nasabahModel!.noHp,
              nasabahModel!.noRek,
            ).then((e) {
              Navigator.pop(context);
              if (e['value'] == 1) {
                getNasabah();
                nasabahModel = null;
                kantorModel = null;
                acctTypeModel = null;
                gender = null;
                tglLahir.clear();
                noHp.clear();
                namarek.clear();
                norek.clear();
                namaLengkap.clear();
                nik.clear();
                image = null;
                image2 = null;
                notifyListeners();
                informationDialog(context, "Informasi", e['message']);
              } else {
                informationDialog(context, "Informasi", e['message']);
              }
            });
          } else {
            Navigator.pop(context);
            informationDialog(context, "Error", value['message']);
          }
        });
      } else {
        Navigator.pop(context);
        DialogCustom().showLoading(context);

        if (image == null || image2 == null) {
          Navigator.pop(context);
          informationDialog(context, "Error", "Foto KTP dan Selfie wajib diisi");
          return;
        }

        final pathSelfie = await image!.readAsBytes();
        final pathKtp = await image2!.readAsBytes();

        var imageSelfi = "_${DateTime.now().millisecondsSinceEpoch}.jpg";
        var imageKtp = "${DateTime.now().millisecondsSinceEpoch}__.jpg";

        NasabahRepository.insertGallery(
          token,
          NetworkURL.insertGallery(),
          pathKtp,
          imageKtp,
          pathSelfie,
          imageSelfi,
        ).then((value) {
          if (value['value'] == 1) {
            final data = value['data'];

            final ktpPath = data['ktp_path'];
            final selfiePath = data['selfie_path'];

            NasabahRepository.insertAkunCMS(
              token,
              NetworkURL.insertAKunCMS(),
              users!.usersId,
              users!.bprId,
              users!.kodeKantor,
              acctTypeModel!.kdAcc,
              gender!,
              tglLahir.text.trim(),
              noHp.text.trim(),
              namarek.text.trim(),
              norek.text.trim(),
              namarek.text.trim(),
              nik.text.trim(),
              ktpPath,
              selfiePath,
            ).then((e) {
              Navigator.pop(context);
              if (e['value'] == 1) {
                getNasabah();
                namaLengkap.clear();
                namarek.clear();
                norek.clear();
                noHp.clear();
                nik.clear();
                tglLahir.clear();
                image = null;
                image2 = null;
                notifyListeners();
                informationDialog(context, "Informasi", e['message']);
              } else {
                informationDialog(context, "Informasi", e['message']);
              }
            });
          } else {
            Navigator.pop(context);
            informationDialog(context, "Error", value['message']);
          }
        });
      }
    }
  }

  var hide = true;

  gantihide() {
    hide = !hide;
    notifyListeners();
  }

  var semua = false;

  gantisemua() {
    semua = !semua;
    if (semua) {
      listAdd.addAll(list);
    } else {
      listAdd.clear();
    }
    notifyListeners();
  }

  pilihSatuan(NsaabahModel value) async {
    if (listAdd.isEmpty) {
      listAdd.add(value);
    } else {
      if (listAdd.where((element) => element == value).isNotEmpty) {
        listAdd.remove(value);
      } else {
        listAdd.add(value);
      }
    }
    notifyListeners();
  }

  generatedMpin() async {
    if (listAdd.isEmpty) {
      CustomDialog.messageResponse(context, "Pilih Nasabah");
    } else {
      generated();
    }
  }

  generated() async {
    if (listAdd.isEmpty) {
      CustomDialog.messageResponse(context, "Pilih Nasabah");
      return;
    }

    final nasabah = listAdd.first;

    DialogCustom().showLoading(context);

    NasabahRepository.generatedMpin(
      token,
      NetworkURL.generatedMpin(),
      users!.kodeKantor,
      users!.bprId,
      users!.usersId,
      nasabah.noHp,
      nasabah.noRek,
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        getNasabah();
        listAdd.clear();
        CustomDialog.messageResponse(context, value['message']);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    }).catchError((err) {
      Navigator.pop(context);
      CustomDialog.messageResponse(context, err.toString());
    });
  }

  var isLoading = true;
  List<NsaabahModel> list = [];
  List<NsaabahModel> listAdd = [];

  Future getNasabah() async {
    isLoading = true;
    list.clear();
    NasabahRepository.getNasabah(
      token,
      NetworkURL.getListNasbah(),
      users!.usersId,
      users!.bprId,
      users!.kodeKantor,
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['data']) {
          list.add(NsaabahModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  List<dynamic>? cellValues;
  String? classSelect;
  NsaabahModel? nasabahModel;

  void onSelectionChanged(List<dynamic> addedRows, List<dynamic> removedRows) {
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      nasabahModel = list.where((element) => element.noRek == cellValues![2]).first;
      edit();
      notifyListeners();
    }
  }

  var editData = false;

  edit() {
    editData = true;
    key.currentState!.openEndDrawer();
    controller = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    controller2 = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    acctTypeModel = listAccount.where((element) => element.kdAcc == nasabahModel!.acctType).first;
    namaLengkap.text = nasabahModel!.nama;
    namarek.text = nasabahModel!.namaRek;
    noHp.text = nasabahModel!.noHp;
    nik.text = nasabahModel!.noKtp;
    norek.text = nasabahModel!.noRek;
    gender = nasabahModel!.gender;
    tglLahir.text = nasabahModel!.tglLahir;
    genderError = null;
    acctTypeError = null;
    rekeningError = null;
    currentStep = 0;
    tombolcapture = false;
    tombolcaptureselfie = false;
    notifyListeners();
  }

  confirm() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
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
                const SizedBox(height: 16),
                Text(
                  "Anda yakin akan menghapus ${nasabahModel!.nama}?",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
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
                    const SizedBox(width: 16),
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
    NasabahRepository.insertAkunCMS(
      token,
      NetworkURL.deleteAkunCms(),
      users!.usersId,
      kantorModel!.bpr_id,
      kantorModel!.kdKantor,
      acctTypeModel!.kdAcc,
      gender!,
      tglLahir.text.trim(),
      noHp.text.trim(),
      namarek.text.trim(),
      norek.text.trim(),
      namaLengkap.text.trim(),
      nik.text.trim(),
      nasabahModel!.fhoto1,
      nasabahModel!.fhoto2,
    ).then((e) {
      Navigator.pop(context);
      if (e['value'] == 1) {
        getNasabah();
        informationDialog(context, "Informasi", e['message']);
      } else {
        informationDialog(context, "Informasi", e['message']);
      }
    });
  }

  int currentStep = 0;

  void onStepContinue() {
    if (currentStep == 0) {
      final valid = validateStepDataDiri();
      if (!valid) return;

      currentStep++;
      notifyListeners();
      return;
    }

    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    } else {
      cek();
      notifyListeners();
    }
  }

  void onStepCancel() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    } else {
      Navigator.pop(context);
    }
  }

  bool switchFoto = false;

  void changeFoto(bool value) {
    switchFoto = value;
    notifyListeners();
  }

  cancelKTP() {
    image2 = null;
    controller2 = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    openKTP();
    notifyListeners();
  }

  cancelSelfi() {
    image = null;
    controller = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    openKTPSelfi();
    notifyListeners();
  }
}
