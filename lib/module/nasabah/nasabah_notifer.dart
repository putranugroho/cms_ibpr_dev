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

  String noCif = "";
  String bridgeKtpPath = "";
  String bridgeSelfiePath = "";
  int photoBridgeVersion = 0;

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
    noCif = "";
    bridgeKtpPath = "";
    bridgeSelfiePath = "";
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

  String _stringValue(dynamic value) {
    if (value == null) return "";
    return value.toString().trim();
  }

  String _extractNoCif(dynamic data) {
    final keys = [
      'no_cif',
      'nocif',
      'noCif',
      'NO_CIF',
      'NO CIF',
      'cif',
      'CIF',
    ];

    if (data is Map) {
      for (final key in keys) {
        final value = data[key];
        final text = _stringValue(value);
        if (text.isNotEmpty) return text;
      }

      for (final value in data.values) {
        final found = _extractNoCif(value);
        if (found.isNotEmpty) return found;
      }
    }

    if (data is List) {
      for (final item in data) {
        final found = _extractNoCif(item);
        if (found.isNotEmpty) return found;
      }
    }

    return "";
  }

  String _noCifFromModel() {
    try {
      return _stringValue((nasabahModel as dynamic).noCif);
    } catch (_) {
      return "";
    }
  }

  String _validPhotoPath(dynamic value) {
    final path = (value ?? '').toString().trim();
    if (path.isEmpty || path.toLowerCase() == 'null') return '';
    return path;
  }

  String get currentKtpPhotoPath {
    final bridgePath = _validPhotoPath(bridgeKtpPath);
    if (bridgePath.isNotEmpty) return bridgePath;

    return _validPhotoPath(nasabahModel?.fhoto1);
  }

  String get currentSelfiePhotoPath {
    final bridgePath = _validPhotoPath(bridgeSelfiePath);
    if (bridgePath.isNotEmpty) return bridgePath;

    return _validPhotoPath(nasabahModel?.fhoto2);
  }

  bool get hasCurrentKtpPhoto => currentKtpPhotoPath.trim().isNotEmpty;

  bool get hasCurrentSelfiePhoto => currentSelfiePhotoPath.trim().isNotEmpty;

  bool get hasCurrentPhotoPair => hasCurrentKtpPhoto && hasCurrentSelfiePhoto;

  String _withCacheBuster(String url) {
    if (url.trim().isEmpty) return url;

    final separator = url.contains("?") ? "&" : "?";
    return "$url${separator}v=$photoBridgeVersion";
  }

  String get currentKtpPhotoUrl {
    final path = currentKtpPhotoPath.trim();
    if (path.isEmpty) return "";

    return _withCacheBuster(
      NetworkURL.photoView(
        type: "ktp",
        fileOrPath: path,
      ),
    );
  }

  String get currentSelfiePhotoUrl {
    final path = currentSelfiePhotoPath.trim();
    if (path.isEmpty) return "";

    return _withCacheBuster(
      NetworkURL.photoView(
        type: "selfie",
        fileOrPath: path,
      ),
    );
  }

  Future<void> loadNasabahPhotoBridge({
    String? forceNoCif,
  }) async {
    final selectedNoCif = (forceNoCif ?? "").trim().isNotEmpty
        ? forceNoCif!.trim()
        : noCif.trim().isNotEmpty
            ? noCif.trim()
            : _noCifFromModel();

    debugPrint("[NASABAH][PHOTO_BRIDGE][START] no_cif=$selectedNoCif");

    if (selectedNoCif.isEmpty) {
      debugPrint("[NASABAH][PHOTO_BRIDGE][SKIP] no_cif kosong");
      bridgeKtpPath = "";
      bridgeSelfiePath = "";
      photoBridgeVersion = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      return;
    }

    try {
      final value = await NasabahRepository.inquiryNasabahPhotoBridge(
        token,
        NetworkURL.nasabahPhotoBridge(),
        users!.bprId,
        selectedNoCif,
      );

      debugPrint("[NASABAH][PHOTO_BRIDGE][RESPONSE] $value");

      if (value['value'] == 1 && value['data'] is Map) {
        final data = Map<String, dynamic>.from(value['data']);

        bridgeKtpPath = (data['foto_ktp_path'] ?? "").toString().trim();
        bridgeSelfiePath = (data['foto_selfie_path'] ?? "").toString().trim();
        noCif = selectedNoCif;
      } else {
        bridgeKtpPath = "";
        bridgeSelfiePath = "";
      }
    } catch (e) {
      debugPrint("[NASABAH][PHOTO_BRIDGE][ERROR] $e");
      bridgeKtpPath = "";
      bridgeSelfiePath = "";
    }

    photoBridgeVersion = DateTime.now().millisecondsSinceEpoch;

    debugPrint("[NASABAH][PHOTO_BRIDGE][FINAL_KTP] $bridgeKtpPath");
    debugPrint("[NASABAH][PHOTO_BRIDGE][FINAL_SELFIE] $bridgeSelfiePath");

    notifyListeners();
  }

  Future<void> upsertNasabahPhotoBridgeCMS({
    required String ktpPath,
    required String selfiePath,
  }) async {
    final selectedNoCif = noCif.trim().isNotEmpty ? noCif.trim() : _noCifFromModel();

    if (selectedNoCif.isEmpty) {
      debugPrint("UPSERT BRIDGE SKIPPED: no_cif kosong");
      return;
    }

    try {
      final value = await NasabahRepository.upsertNasabahPhotoBridgeCMS(
        token,
        NetworkURL.nasabahPhotoBridge(),
        users!.bprId,
        selectedNoCif,
        noHp.text.trim(),
        ktpPath,
        selfiePath,
      );

      if (value['value'] == 1 && value['data'] is Map) {
        final data = Map<String, dynamic>.from(value['data']);
        bridgeKtpPath = (data['foto_ktp_path'] ?? ktpPath).toString();
        bridgeSelfiePath = (data['foto_selfie_path'] ?? selfiePath).toString();
      }
    } catch (e) {
      debugPrint("UPSERT BRIDGE ERROR: $e");
    }
  }

  Future<String> inquiryNoCifByRekening({
    required String noRekening,
    bool fillNamaRekening = false,
  }) async {
    final rekening = noRekening.trim();

    if (rekening.isEmpty) {
      return "";
    }

    final invoice = DateTime.now().microsecondsSinceEpoch.toString();

    debugPrint("[NASABAH][INQUIRY_REK][START] no_rek=$rekening");

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
      rekening,
      "2",
    );

    debugPrint("[NASABAH][INQUIRY_REK][RESPONSE] $value");

    if (value['value'] != 1) {
      rekeningError = value['message']?.toString() ?? "Inquiry rekening gagal";
      return "";
    }

    final data = value['data'];
    final selectedNoCif = _extractNoCif(data);

    debugPrint("[NASABAH][INQUIRY_REK][NO_CIF] $selectedNoCif");

    if (fillNamaRekening) {
      namarek.text = (data?['nama'] ?? data?['nama_rek'] ?? namarek.text).toString();
    }

    noCif = selectedNoCif;
    rekeningError = null;

    return selectedNoCif;
  }

  inquery() async {
    if (norek.text.trim().isEmpty) {
      informationDialog(context, "Error", "No. rekening wajib diisi");
      return;
    }

    showSafeLoading();

    try {
      bridgeKtpPath = "";
      bridgeSelfiePath = "";
      noCif = "";
      rekeningError = null;
      photoBridgeVersion = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();

      final selectedNoCif = await inquiryNoCifByRekening(
        noRekening: norek.text.trim(),
        fillNamaRekening: true,
      );

      if (selectedNoCif.isEmpty) {
        closeSafeLoading();
        informationDialog(
          context,
          "Error",
          rekeningError ?? "No CIF tidak ditemukan dari inquiry rekening",
        );
        return;
      }

      await loadNasabahPhotoBridge(forceNoCif: selectedNoCif);

      closeSafeLoading();
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
      final hasNewKtp = image2 != null;
      final hasNewSelfie = image != null;

      if (hasNewKtp != hasNewSelfie) {
        informationDialog(
          context,
          "Error",
          "Foto KTP dan Selfie KTP harus tersedia berpasangan.",
        );
        return;
      }

      if (!hasNewKtp && !hasCurrentPhotoPair) {
        informationDialog(
          context,
          "Error",
          "Foto KTP dan Selfie KTP wajib tersedia, baik dari hasil tarik foto maupun kamera.",
        );
        return;
      }

      _isSubmitting = true;

      if (!editData) {
        final usingExistingBridgePhotos = image == null && image2 == null;

        if (usingExistingBridgePhotos) {
          if (!hasCurrentKtpPhoto) {
            _isSubmitting = false;
            informationDialog(
              context,
              "Error",
              "Foto KTP wajib diisi. Silakan buka kamera atau pastikan foto KTP tersedia di photo bridge.",
            );
            return;
          }

          if (!hasCurrentSelfiePhoto) {
            _isSubmitting = false;
            informationDialog(
              context,
              "Error",
              "Foto Selfie KTP wajib diisi. Silakan buka kamera atau pastikan foto selfie tersedia di photo bridge.",
            );
            return;
          }
        } else if (image == null || image2 == null) {
          _isSubmitting = false;
          informationDialog(
            context,
            "Error",
            "Jika memakai foto baru, Foto KTP dan Selfie KTP harus difoto bersamaan.",
          );
          return;
        }
      }
      if (editData) {
        await closeFormOnly();
        showSafeLoading();

        final bool changeSelfie = image != null;
        final bool changeKtp = image2 != null;

        Future<void> submitUpdate({
          required String ktpFile,
          required String selfieFile,
          bool syncBridge = false,
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
              if (syncBridge) {
                await upsertNasabahPhotoBridgeCMS(
                  ktpPath: ktpFile,
                  selfiePath: selfieFile,
                );
              }

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
            ktpFile: currentKtpPhotoPath,
            selfieFile: currentSelfiePhotoPath,
            syncBridge: false,
          );
          return;
        }

        if (changeSelfie != changeKtp) {
          _isSubmitting = false;
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
              syncBridge: true,
            );
          } else {
            _isSubmitting = false;
            closeSafeLoading();
            informationDialog(context, "Error", value['message']);
          }
        }).catchError((err) {
          _isSubmitting = false;
          closeSafeLoading();
          informationDialog(context, "Error", err.toString());
        });

        return;
      } else {
        await closeFormOnly();
        showSafeLoading();

        Future<void> submitInsert({
          required String ktpPath,
          required String selfiePath,
          bool syncBridge = false,
        }) async {
          try {
            final e = await NasabahRepository.insertAkunCMS(
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
            );

            closeSafeLoading();
            _isSubmitting = false;

            if (e['value'] == 1) {
              if (syncBridge) {
                await upsertNasabahPhotoBridgeCMS(
                  ktpPath: ktpPath,
                  selfiePath: selfiePath,
                );
              }

              await disposeCamera();
              getNasabah();
              resetForm();
              informationDialog(context, "Informasi", e['message']);
            } else {
              informationDialog(context, "Informasi", e['message']);
            }
          } catch (err) {
            closeSafeLoading();
            _isSubmitting = false;
            informationDialog(context, "Error", err.toString());
          }
        }

        final useExistingBridgePhotos = image == null && image2 == null && hasCurrentPhotoPair;

        if (useExistingBridgePhotos) {
          await submitInsert(
            ktpPath: currentKtpPhotoPath,
            selfiePath: currentSelfiePhotoPath,
            syncBridge: false,
          );
          return;
        }

        if (image == null || image2 == null) {
          closeSafeLoading();
          _isSubmitting = false;
          informationDialog(
            context,
            "Error",
            "Foto KTP dan Selfie wajib diisi. Jika memakai foto baru, keduanya harus difoto bersamaan.",
          );
          return;
        }

        try {
          final pathSelfie = await image!.readAsBytes();
          final pathKtp = await image2!.readAsBytes();

          final imageSelfi = "_${DateTime.now().millisecondsSinceEpoch}.jpg";
          final imageKtp = "${DateTime.now().millisecondsSinceEpoch}__.jpg";

          final value = await NasabahRepository.insertGallery(
            token,
            NetworkURL.insertGallery(),
            pathKtp,
            imageKtp,
            pathSelfie,
            imageSelfi,
          );

          if (value['value'] == 1) {
            final data = Map<String, dynamic>.from(value['data'] ?? {});

            final ktpPath = (data['ktp_path'] ?? imageKtp).toString();
            final selfiePath = (data['selfie_path'] ?? imageSelfi).toString();

            await submitInsert(
              ktpPath: ktpPath,
              selfiePath: selfiePath,
              syncBridge: true,
            );
          } else {
            closeSafeLoading();
            _isSubmitting = false;
            informationDialog(context, "Error", value['message']);
          }
        } catch (err) {
          closeSafeLoading();
          _isSubmitting = false;
          informationDialog(context, "Error", err.toString());
        }
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

    noCif = "";
    bridgeKtpPath = "";
    bridgeSelfiePath = "";
    photoBridgeVersion = DateTime.now().millisecondsSinceEpoch;

    genderError = null;
    acctTypeError = null;
    rekeningError = null;
    currentStep = 0;
    tombolcapture = false;
    tombolcaptureselfie = false;

    notifyListeners();

    showSafeLoading();

    try {
      final selectedNoCif = await inquiryNoCifByRekening(
        noRekening: nasabahModel!.noRek,
        fillNamaRekening: false,
      );

      if (selectedNoCif.isNotEmpty) {
        await loadNasabahPhotoBridge(forceNoCif: selectedNoCif);
      } else {
        noCif = _noCifFromModel();

        debugPrint(
          "[NASABAH][EDIT][NO_CIF_FALLBACK_FROM_MODEL] $noCif",
        );

        await loadNasabahPhotoBridge(forceNoCif: noCif);
      }

      closeSafeLoading();
    } catch (e) {
      closeSafeLoading();

      noCif = _noCifFromModel();

      debugPrint("[NASABAH][EDIT][INQUIRY_REK_ERROR] $e");
      debugPrint("[NASABAH][EDIT][NO_CIF_FALLBACK_FROM_MODEL] $noCif");

      await loadNasabahPhotoBridge(forceNoCif: noCif);
    }
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
    if (image2 == null && !hasCurrentKtpPhoto) {
      informationDialog(context, "Error", "Foto KTP wajib diisi");
      return false;
    }
    return true;
  }

  bool validateFotoSelfieStep() {
    if (image == null && !hasCurrentSelfiePhoto) {
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
    noCif = "";
    bridgeKtpPath = "";
    bridgeSelfiePath = "";

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
