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
  getProfile() async {
    cameras = await availableCameras();
    notifyListeners();
    Pref().getUsers().then((value) {
      users = value;
      getAccountType();
      getNasabah();
      notifyListeners();
      if (cameras.isNotEmpty) {
        print("ketemu");
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
                        const SizedBox(
                          height: 6,
                        ),
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
                                          ResolutionPreset.max);
                                      controller2 = CameraController(
                                          cameras[selectCamera!],
                                          ResolutionPreset.max);
                                      notifyListeners();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(cameras[i].name)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            })
                      ],
                    ),
                  ),
                );
              });
        } else {
          ketemuCamera = false;
          notifyListeners();
        }
      } else {
        ketemuCamera = false;
        notifyListeners();
      }

      // controller = CameraController(cameras[1], ResolutionPreset.max);
      // controller2 = CameraController(cameras[1], ResolutionPreset.max);
    });
  }

  var isLoadingAccount = true;
  List<AcctTypeModel> listAccount = [];
  AcctTypeModel? acctTypeModel;
  pilihAcctType(AcctTypeModel value) {
    acctTypeModel = value;
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
    notifyListeners();
  }

  gantiTanggal() async {
    var pickedendDate = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1930),
        lastDate: DateTime.now()));

    tglLahir.text = DateFormat("yyyy-MM-dd")
        .format(DateTime.parse(pickedendDate.toString()));
    notifyListeners();
  }

  List<KantorModel> listKantor = [];
  KantorModel? kantorModel;
  pilihKantor(KantorModel value) {
    kantorModel = value;
    notifyListeners();
  }

  final keyForm = GlobalKey<FormState>();
  getAccountType() async {
    isLoadingAccount = true;
    list.clear();
    listKantor.clear();
    notifyListeners();
    AccountRepository.getListAll(
            token, NetworkURL.getListAcctType(), users!.usersId, users!.bprId)
        .then((value) {
      if (value['value'] == 1) {
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
    // super.dispose();
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  tambah() {
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
    key.currentState!.openEndDrawer();
    editData = false;
    image = null;
    image2 = null;
    controller = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    controller2 =
        CameraController(cameras[selectCamera!], ResolutionPreset.max);
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
            // Handle access errors here.
            // print("CameraAccessDenied");
            break;
          default:
            // print(e.code); // Handle other errors here.
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
            // Handle access errors here.
            // print("CameraAccessDenied");
            break;
          default:
            // print(e.code); // Handle other errors here.
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
      // ignore: empty_catches
    } catch (e) {}
    tombolcapture = false;
    notifyListeners();
  }

  captureSelfiKTP() async {
    try {
      image = await controller!.takePicture();

      notifyListeners();
      // ignore: empty_catches
    } catch (e) {}
    tombolcaptureselfie = false;
    notifyListeners();
  }

  inquery() async {
    DialogCustom().showLoading(context);
    var invoice = DateTime.now().microsecondsSinceEpoch.toString();
    NasabahRepository.inqueryRekCMS(
            token,
            NetworkURL.inqueryRekCMS(),
            users!.usersId,
            // kantorModel!.kdBank,
            users!.bprId,
            "0200",
            "TRX",
            DateFormat('yyMMddHHmmss').format(DateTime.now()),
            DateFormat('yyMMddHHmmss').format(DateTime.now()),
            invoice,
            norek.text.trim(),
            "2")
        .then((value) {
          print(value);
      Navigator.pop(context);
      if (value['value'] == 1) {
        namarek.text = value['data']['nama'];
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

          // // selfi = img.decodeImage(bytes);
          imageSelfi =
              "_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        }
        if (image2 != null) {
          path2 = await image2!.readAsBytes();

          imageKtp =
              "${DateTime.now().millisecondsSinceEpoch.toString()}__.jpg";
        }

        NasabahRepository.insertGallery(token, NetworkURL.insertGallery(),
                path2, imageKtp, path, imageSelfi)
            .then((value) {
          if (value['value'] == 1) {
            NasabahRepository.updateAkunCMS(
              token,
              NetworkURL.updateAkunCms(),
              users!.usersId,
              kantorModel!.kdBank,
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
        final path = await image!.readAsBytes();

        // // selfi = img.decodeImage(bytes);
        var imageSelfi =
            "_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

        final path2 = await image2!.readAsBytes();

        var imageKtp =
            "${DateTime.now().millisecondsSinceEpoch.toString()}__.jpg";

        NasabahRepository.insertGallery(token, NetworkURL.insertGallery(),
                path2, imageKtp, path, imageSelfi)
            .then((value) {
          if (value['value'] == 1) {
            NasabahRepository.insertAkunCMS(
                    token,
                    NetworkURL.insertAKunCMS(),
                    users!.usersId,
                    // kantorModel!.kdBank,
                    users!.bprId,
                    // kantorModel!.kdKantor,
                    users!.kodeKantor,
                    acctTypeModel!.kdAcc,
                    gender!,
                    tglLahir.text.trim(),
                    noHp.text.trim(),
                    namarek.text.trim(),
                    norek.text.trim(),
                    // namaLengkap.text.trim(),
                    namarek.text.trim(),
                    nik.text.trim(),
                    imageKtp,
                    imageSelfi)
                .then((e) {
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
    DialogCustom().showLoading(context);
    // print(jsonEncode(listAdd));
    NasabahRepository.generatedMpin(
            token,
            NetworkURL.generatedMpin(),
            users!.kodeKantor,
            users!.bprId,
            users!.usersId,
            jsonEncode(listAdd))
        .then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        getNasabah();
        listAdd.clear();
        CustomDialog.messageResponse(context, value['message']);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }

  var isLoading = true;
  List<NsaabahModel> list = [];
  List<NsaabahModel> listAdd = [];
  Future getNasabah() async {
    isLoading = true;
    list.clear();
    NasabahRepository.getNasabah(
            token, NetworkURL.getListNasbah(), users!.usersId, users!.bprId, users!.kodeKantor)
        .then((value) {
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
    // Cetak informasi tentang data yang dipilih
    for (final addedRow in addedRows) {
      final selectedData = addedRow.getCells();
      cellValues = selectedData.map((cell) => cell.value).toList();
      // var kategoriNew = cellValues![2];
      // phoneSelect = cellValues![6];
      nasabahModel =
          list.where((element) => element.noRek == cellValues![2]).first;
      // print("${cellValues![2]}");
      edit();
      notifyListeners();
      // transaksiModel =
      //     list.where((element) => element.invoice == cellValues![7]).first;
      // notifyListeners();
      // print(selectedData);
    }
  }

  var editData = false;
  edit() {
    editData = true;
    key.currentState!.openEndDrawer();
    controller = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    controller2 =
        CameraController(cameras[selectCamera!], ResolutionPreset.max);
    // kantorModel = listKantor
    //     .where((element) => element.kdKantor == nasabahModel!.kdKantor)
    //     .first;
    acctTypeModel = listAccount
        .where((element) => element.kdAcc == nasabahModel!.acctType)
        .first;
    namaLengkap.text = nasabahModel!.nama;
    namarek.text = nasabahModel!.namaRek;
    noHp.text = nasabahModel!.noHp;
    nik.text = nasabahModel!.noKtp;
    norek.text = nasabahModel!.noRek;
    gender = nasabahModel!.gender;
    tglLahir.text = nasabahModel!.tglLahir;
    currentStep = 0;
    tombolcapture = false;
    tombolcaptureselfie = false;
    // image = nasabahModel!.fhoto1;
    // image2 = nasabahModel!.fhoto2;
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
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Anda yakin akan menghapus ${nasabahModel!.nama}?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
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
    NasabahRepository.insertAkunCMS(
            token,
            NetworkURL.deleteAkunCms(),
            users!.usersId,
            kantorModel!.kdBank,
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
            nasabahModel!.fhoto2)
        .then((e) {
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
    if (currentStep < 2) {
      // if (currentStep == 0) {
      // if (keyForm.currentState!.validate()) {
      currentStep++;
      //   }
      // }
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
    print("ini switch = $switchFoto");
    notifyListeners();
  }

  cancelKTP() {
    image2 = null;
    controller2 =
        CameraController(cameras[selectCamera!], ResolutionPreset.max);
    openKTP();
    notifyListeners();
  }

  cancelSelfi() {
    image = null;
    controller = CameraController(cameras[selectCamera!], ResolutionPreset.max);
    // controller!.value.isInitialized;
    // CameraPreview(controller!);
    // controller?.dispose();
    openKTPSelfi();
    // controller?.resumePreview();
    notifyListeners();
  }
}
