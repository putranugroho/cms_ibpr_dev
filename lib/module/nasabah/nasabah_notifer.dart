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
  bool _isSubmitting = false;
  CameraController? controller;
  CameraController? controller2;

  String? genderError;
  String? acctTypeError;
  String? rekeningError;

  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getAccountType();
      getNasabah();
      notifyListeners();
    });
  }

  Future<bool> prepareCamera() async {
    try {
      if (cameras.isEmpty) {
        cameras = await availableCameras();
      }

      if (cameras.isEmpty) {
        informationDialog(context, "Error", "Kamera tidak ditemukan");
        return false;
      }

      selectCamera ??= 0;

      controller ??= CameraController(
        cameras[selectCamera!],
        ResolutionPreset.max,
        enableAudio: false,
      );

      controller2 ??= CameraController(
        cameras[selectCamera!],
        ResolutionPreset.max,
        enableAudio: false,
      );

      return true;
    } catch (e) {
      informationDialog(context, "Error", "Gagal mengakses kamera: $e");
      return false;
    }
  }

  Future<void> disposeCamera() async {
    try {
      if (controller != null) {
        if (controller!.value.isInitialized) {
          await controller!.dispose();
        }
        controller = null;
      }

      if (controller2 != null) {
        if (controller2!.value.isInitialized) {
          await controller2!.dispose();
        }
        controller2 = null;
      }

      tombolcapture = false;
      tombolcaptureselfie = false;
    } catch (_) {
      controller = null;
      controller2 = null;
      tombolcapture = false;
      tombolcaptureselfie = false;
    }
  }

  var isLoadingAccount = true;
  List<AcctTypeModel> listAccount = [];
  AcctTypeModel? acctTypeModel;
  String selectedAcctType = "";

  pilihAcctType(AcctTypeModel value) {
    acctTypeModel = value;
    selectedAcctType = value.kdAcc;
    acctTypeError = null;

    debugPrint("SELECTED ACCT TYPE: $selectedAcctType");

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

    if (selectedAcctType.trim().isEmpty) {
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

        final rawData = value['data'];
        if (rawData is List) {
          for (final raw in rawData) {
            listAccount.add(AcctTypeModel.fromJson(Map<String, dynamic>.from(raw)));
          }
        }

        final rawKantor = value['kantor'];
        if (rawKantor is List) {
          for (final raw in rawKantor) {
            listKantor.add(KantorModel.fromJson(Map<String, dynamic>.from(raw)));
          }
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

  close() async {
    closeSafeLoading();

    if (controller != null) {
      await controller!.dispose();
      controller = null;
    }

    if (controller2 != null) {
      await controller2!.dispose();
      controller2 = null;
    }

    notifyListeners();
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  tambah() async {
    await disposeCamera();
    nasabahModel = null;
    kantorModel = null;
    acctTypeModel = null;
    selectedAcctType = "";
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
    currentStep = 0;
    tombolcapture = false;
    tombolcaptureselfie = false;
    notifyListeners();
  }

  bool tombolcapture = false;

  openKTP() async {
    final ready = await prepareCamera();
    if (!ready) return;

    try {
      if (controller2 == null || controller2!.value.isInitialized == false) {
        controller2 = CameraController(
          cameras[selectCamera!],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await controller2!.initialize();
      }

      tombolcapture = true;
      notifyListeners();
    } catch (e) {
      tombolcapture = false;
      notifyListeners();
      informationDialog(context, "Error", "Gagal membuka kamera KTP: $e");
    }
  }

  bool tombolcaptureselfie = false;

  openKTPSelfi() async {
    final ready = await prepareCamera();
    if (!ready) return;

    try {
      if (controller == null || controller!.value.isInitialized == false) {
        controller = CameraController(
          cameras[selectCamera!],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await controller!.initialize();
      }

      tombolcaptureselfie = true;
      notifyListeners();
    } catch (e) {
      tombolcaptureselfie = false;
      notifyListeners();
      informationDialog(context, "Error", "Gagal membuka kamera selfie: $e");
    }
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

    showSafeLoading();

    try {
      final invoice = DateTime.now().microsecondsSinceEpoch.toString();

      final value = await NasabahRepository.inqueryRekCMS(
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
      );

      closeSafeLoading();

      if (value['value'] == 1) {
        final data = value['data'];

        namarek.text = (data?['nama'] ?? data?['nama_rek'] ?? "").toString();
        rekeningError = null;

        notifyListeners();
      } else {
        informationDialog(
          context,
          "Error",
          value['message']?.toString() ?? "Inquiry rekening gagal",
        );
      }
    } catch (e) {
      closeSafeLoading();
      informationDialog(context, "Error", e.toString());
    }
  }

  bool _isLoadingOpen = false;

  void showSafeLoading() {
    if (_isLoadingOpen) return;
    _isLoadingOpen = true;
    DialogCustom().showLoading(context);
  }

  void closeSafeLoading() {
    if (!_isLoadingOpen) return;

    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop();
    }

    _isLoadingOpen = false;
  }

  Future<void> closeFormOnly() async {
    if (key.currentState?.isEndDrawerOpen ?? false) {
      Navigator.of(context).pop();
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  cek() async {
    if (keyForm.currentState!.validate()) {
      _isSubmitting = true;
      if (editData) {
        await closeFormOnly();
        showSafeLoading();

        final bool changeSelfie = image != null;
        final bool changeKtp = image2 != null;

        Future<void> submitUpdate({
          required String ktpFile,
          required String selfieFile,
        }) async {
          NasabahRepository.updateAkunCMS(
            token,
            NetworkURL.updateAkunCms(),
            users!.usersId,
            users!.bprId,
            nasabahModel!.kdKantor.toString().isNotEmpty ? nasabahModel!.kdKantor.toString() : users!.kodeKantor,
            selectedAcctType,
            gender!,
            tglLahir.text.trim(),
            noHp.text.trim(),
            namarek.text.trim(),
            norek.text.trim(),
            namaLengkap.text.trim(),
            nik.text.trim(),
            ktpFile,
            selfieFile,
            nasabahModel!.noHp,
            nasabahModel!.noRek,
          ).then((e) async {
            closeSafeLoading();
            _isSubmitting = false;
            if (e['value'] == 1) {
              await disposeCamera();
              getNasabah();
              resetForm();
              informationDialog(context, "Informasi", e['message']);
            } else {
              informationDialog(context, "Informasi", e['message']);
            }
          }).catchError((err) {
            _isSubmitting = false;
            closeSafeLoading();
            informationDialog(context, "Error", err.toString());
          });
        }

        if (!changeSelfie && !changeKtp) {
          await submitUpdate(
            ktpFile: nasabahModel!.fhoto1.toString(),
            selfieFile: nasabahModel!.fhoto2.toString(),
          );
          return;
        }

        if (changeSelfie != changeKtp) {
          closeSafeLoading();
          informationDialog(
            context,
            "Error",
            "Jika ingin mengganti foto, Foto KTP dan Selfie KTP harus diganti bersamaan.",
          );
          return;
        }

        final pathSelfie = await image!.readAsBytes();
        final pathKtp = await image2!.readAsBytes();

        final imageSelfi = "_${DateTime.now().millisecondsSinceEpoch}.jpg";
        final imageKtp = "${DateTime.now().millisecondsSinceEpoch}__.jpg";

        NasabahRepository.insertGallery(
          token,
          NetworkURL.insertGallery(),
          pathKtp,
          imageKtp,
          pathSelfie,
          imageSelfi,
        ).then((value) async {
          if (value['value'] == 1) {
            final data = value['data'];

            await submitUpdate(
              ktpFile: (data['ktp_path'] ?? imageKtp).toString(),
              selfieFile: (data['selfie_path'] ?? imageSelfi).toString(),
            );
          } else {
            closeSafeLoading();
            informationDialog(context, "Error", value['message']);
          }
        }).catchError((err) {
          closeSafeLoading();
          informationDialog(context, "Error", err.toString());
        });

        return;
      } else {
        await closeFormOnly();
        showSafeLoading();

        if (image == null || image2 == null) {
          closeSafeLoading();
          informationDialog(context, "Error", "Foto KTP dan Selfie wajib diisi");
          _isSubmitting = false;
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
              selectedAcctType,
              gender!,
              tglLahir.text.trim(),
              noHp.text.trim(),
              namarek.text.trim(),
              norek.text.trim(),
              namarek.text.trim(),
              nik.text.trim(),
              ktpPath,
              selfiePath,
            ).then((e) async {
              closeSafeLoading();
              _isSubmitting = false;
              if (e['value'] == 1) {
                await disposeCamera();
                getNasabah();
                resetForm();
                informationDialog(context, "Informasi", e['message']);
              } else {
                informationDialog(context, "Informasi", e['message']);
              }
            });
          } else {
            closeSafeLoading();
            _isSubmitting = false;
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

    showSafeLoading();

    NasabahRepository.generatedMpin(
      token,
      NetworkURL.generatedMpin(),
      users!.kodeKantor,
      users!.bprId,
      users!.usersId,
      nasabah.noHp,
      nasabah.noRek,
    ).then((value) {
      closeSafeLoading();
      if (value['value'] == 1) {
        getNasabah();
        listAdd.clear();
        CustomDialog.messageResponse(context, value['message']);
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    }).catchError((err) {
      closeSafeLoading();
      CustomDialog.messageResponse(context, err.toString());
    });
  }

  var isLoading = true;
  List<NsaabahModel> list = [];
  List<NsaabahModel> listAdd = [];

  Future getNasabah() async {
    isLoading = true;
    list.clear();
    notifyListeners();

    try {
      final value = await NasabahRepository.getNasabah(
        token,
        NetworkURL.getListNasbah(),
        users!.usersId,
        users!.bprId,
        users!.kodeKantor,
      );

      if (value['value'] == 1) {
        final rawData = value['data'];

        if (rawData is List) {
          for (final raw in rawData) {
            final item = Map<String, dynamic>.from(raw);
            list.add(NsaabahModel.fromJson(item));
          }
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      informationDialog(context, "Error", e.toString());
    }
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

  edit() async {
    await disposeCamera();
    editData = true;
    key.currentState!.openEndDrawer();
    final matchedAcctType = listAccount.where(
      (element) => element.kdAcc == nasabahModel!.acctType,
    );
    acctTypeModel = matchedAcctType.isNotEmpty ? matchedAcctType.first : null;
    selectedAcctType = acctTypeModel?.kdAcc ?? nasabahModel!.acctType.toString();
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
    closeSafeLoading();
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
                          closeSafeLoading();
                        },
                        name: "No",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonPrimary(
                        onTap: () {
                          closeSafeLoading();
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
    showSafeLoading();
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
      closeSafeLoading();
      if (e['value'] == 1) {
        getNasabah();
        informationDialog(context, "Informasi", e['message']);
      } else {
        informationDialog(context, "Informasi", e['message']);
      }
    });
  }

  int currentStep = 0;

  bool validateFotoKtpStep() {
    if (!editData && image2 == null) {
      informationDialog(context, "Error", "Foto KTP wajib diisi");
      return false;
    }
    return true;
  }

  bool validateFotoSelfieStep() {
    if (!editData && image == null) {
      informationDialog(context, "Error", "Foto Selfie KTP wajib diisi");
      return false;
    }
    return true;
  }

  void onStepContinue() {
    if (currentStep == 0) {
      final valid = validateStepDataDiri();

      if (!valid) return;

      currentStep++;
      notifyListeners();
      return;
    }

    if (currentStep == 1) {
      final valid = validateFotoKtpStep();
      if (!valid) return;

      currentStep++;
      notifyListeners();
      return;
    }

    if (currentStep == 2) {
      final valid = validateFotoSelfieStep();
      if (!valid) return;

      cek();
      notifyListeners();
    }
  }

  void onStepCancel() async {
    await onFormClosed();

    if (key.currentState?.isEndDrawerOpen ?? false) {
      closeSafeLoading();
    }
  }

  void resetForm() {
    nasabahModel = null;
    kantorModel = null;
    acctTypeModel = null;
    selectedAcctType = "";
    gender = null;
    editData = false;
    switchFoto = false;

    tglLahir.clear();
    noHp.clear();
    namarek.clear();
    norek.clear();
    namaLengkap.clear();
    nik.clear();

    image = null;
    image2 = null;
    currentStep = 0;
    tombolcapture = false;
    tombolcaptureselfie = false;

    notifyListeners();
  }

  Future<void> onFormClosed() async {
    if (_isSubmitting) return;

    await disposeCamera();

    image = null;
    image2 = null;
    tombolcapture = false;
    tombolcaptureselfie = false;

    if (hasListeners) {
      notifyListeners();
    }
  }

  bool switchFoto = false;

  void changeFoto(bool value) {
    switchFoto = value;
    notifyListeners();
  }

  cancelKTP() async {
    image2 = null;

    if (controller2 != null) {
      await controller2!.dispose();
      controller2 = null;
    }

    tombolcapture = false;
    notifyListeners();
  }

  cancelSelfi() async {
    image = null;

    if (controller != null) {
      await controller!.dispose();
      controller = null;
    }

    tombolcaptureselfie = false;
    notifyListeners();
  }

  @override
  void dispose() {
    controller?.dispose();
    controller2?.dispose();

    namaLengkap.dispose();
    noHp.dispose();
    nik.dispose();
    norek.dispose();
    namarek.dispose();
    tglLahir.dispose();

    super.dispose();
  }
}
