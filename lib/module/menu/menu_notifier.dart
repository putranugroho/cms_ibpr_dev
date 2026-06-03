import 'dart:convert';

import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/auth/login_page.dart';
import 'package:cms_ibpr/network/network.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/utils/dialog_custom.dart';
import 'package:cms_ibpr/utils/dialog_loading.dart';
import 'package:cms_ibpr/utils/informationdialog.dart';
import 'package:cms_ibpr/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../repository/auth_repository.dart';
import '../../utils/button_custom.dart';
import '../../utils/web/web_close_handler.dart';

class MenuNotifier extends ChangeNotifier {
  final BuildContext context;
  bool isCoreSignin = false;
  bool isCoreStatusAvailable = false;
  bool isSigninSignoffLoading = false;
  bool isStatusCoreLoading = false;
  bool _isAutoLoggingOut = false;
  bool _browserCloseRegistered = false;
  bool _browserClosing = false;
  String coreStatusMessage = "Status core belum tersedia";

  MenuNotifier({required this.context}) {
    getProfile();
  }

  final passForm = GlobalKey<FormState>();

  List<FasilitasAddModel> listFasilitas = [];
  UsersModel? users;
  var isloading = true;
  getProfile() async {
    isloading = true;
    listFasilitas.clear();
    notifyListeners();
    Pref().getFasilitas().then((value) {
      print("RAW LOCAL STORAGE: $value");

      var json = jsonDecode(value);
      print("TOTAL LOCAL: ${json.length}");
      print("ini = $json");
      for (var i = 0; i < json.length; i++) {
        listFasilitas.add(FasilitasAddModel(
          modul: json[i]['modul'],
          menu: json[i]['menu'],
          submenu: json[i]['submenu'],
          subsubmenu: json[i]['subsubmenu'],
          urut: json[i]['urut'],
          flag: json[i]['flag'],
        ));
      }
      print(listFasilitas.length);
    });
    Pref().getUsers().then((value) async {
      users = value;

      if (users != null) {
        final expired = await Pref().isSessionExpired(
          Pref.idleDuration,
        );

        if (expired) {
          await Pref().remove();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );

          return;
        }

        await Pref().setLastActivityNow();
        await getStatusCore();
        await initBrowserCloseHandler();
      }

      isloading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  Future getStatusCore() async {
    if (users == null) return;

    isStatusCoreLoading = true;
    isCoreStatusAvailable = false;
    coreStatusMessage = "Mengambil status core...";
    notifyListeners();

    try {
      final result = await AuthRepository.statusCore(
        NetworkURL.statusCore(),
        users!.bprId,
      );

      final data = result["data"];

      if (result["value"] == 1 && data is Map) {
        final status = (data["status"] ?? "").toString();

        if (status == "1") {
          isCoreSignin = true;
          isCoreStatusAvailable = true;
          coreStatusMessage = "Transaksi sedang AKTIF";
        } else if (status == "0") {
          isCoreSignin = false;
          isCoreStatusAvailable = true;
          coreStatusMessage = "Transaksi sedang NONAKTIF";
        } else {
          isCoreSignin = false;
          isCoreStatusAvailable = false;
          coreStatusMessage = "Status core tidak valid";
        }
      } else {
        isCoreSignin = false;
        isCoreStatusAvailable = false;
        coreStatusMessage = result["message"]?.toString() ?? "Gagal mengambil status core";
      }
    } catch (e) {
      isCoreSignin = false;
      isCoreStatusAvailable = false;
      coreStatusMessage = "Gagal mengambil status core";
      debugPrint("GET STATUS CORE ERROR: $e");
    }

    isStatusCoreLoading = false;
    notifyListeners();
  }

  int page = 0;
  gantipage(int value) {
    page = value;
    notifyListeners();
  }

  confirmSigninSignoff() async {
    if (!isCoreStatusAvailable || isStatusCoreLoading) {
      informationDialog(
        context,
        "Informasi",
        "Status core belum tersedia. Silakan refresh atau cek koneksi gateway.",
      );
      return;
    }

    final nextStatus = isCoreSignin ? "0" : "1";
    final actionText = isCoreSignin ? "SIGN OFF" : "SIGN IN";
    final isSignOff = isCoreSignin;

    final message = isSignOff
        ? "Anda akan melakukan SIGN OFF CORE. Semua transaksi akan dinonaktifkan sementara. Lanjutkan?"
        : "Anda akan melakukan SIGN IN CORE. Transaksi akan diaktifkan kembali. Lanjutkan?";

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
                Row(
                  children: [
                    Icon(
                      isSignOff ? Icons.warning_amber_rounded : Icons.lock_open,
                      color: isSignOff ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Konfirmasi $actionText CORE",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Login : ${users?.usersId ?? "-"}"),
                      Text("BPR ID     : ${users?.bprId ?? "-"}"),
                      Text("Status Baru: $actionText"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ButtonSecondary(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        name: "Batal",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonPrimary(
                        onTap: () {
                          Navigator.pop(context);
                          confirmSigninSignoffFinal(nextStatus, actionText, isSignOff);
                        },
                        name: actionText,
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

  confirmSigninSignoffFinal(
    String nextStatus,
    String actionText,
    bool isSignOff,
  ) async {
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
                Row(
                  children: [
                    Icon(
                      isSignOff ? Icons.warning_amber_rounded : Icons.lock_open,
                      color: isSignOff ? Colors.red : Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Pastikan $actionText CORE?",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isSignOff
                      ? "Apakah Anda benar-benar yakin ingin melakukan SIGN OFF?\n\nSemua transaksi akan dinonaktifkan sementara."
                      : "Apakah Anda benar-benar yakin ingin melakukan SIGN IN?\n\nTransaksi akan diaktifkan kembali.",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ButtonSecondary(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        name: "Tidak",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonPrimary(
                        onTap: () {
                          Navigator.pop(context);
                          signinSignoff(nextStatus);
                        },
                        name: "Ya",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future signinSignoff(String status) async {
    if (users == null) {
      informationDialog(context, "Informasi", "Data user tidak ditemukan");
      return;
    }

    isSigninSignoffLoading = true;
    notifyListeners();

    DialogCustom().showLoading(context);

    try {
      final result = await AuthRepository.signinSignoff(
        NetworkURL.signinSignoff(),
        users!.usersId,
        users!.bprId,
        "WEB",
        status,
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      final code = result["code"]?.toString() ?? "";
      final value = result["value"]?.toString() ?? "";
      final message = result["message"]?.toString() ?? "Proses signin-signoff selesai";

      if (code == "000" || value == "1") {
        await getStatusCore();
        informationDialog(context, "Informasi", message);
      } else {
        informationDialog(context, "Informasi", message);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      informationDialog(context, "Informasi", e.toString());
    }

    isSigninSignoffLoading = false;
    notifyListeners();
  }

  confirmDelete() async {
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
                        "Konfirmasi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Anda yakin akan keluar dari aplikasi?",
                    style: TextStyle(
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
                          remove();
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

  remove() async {
    CustomDialog.loading(context);

    AuthRepository.logOut(
      NetworkURL.logout(),
      users!.bprId,
      users!.usersId,
      users!.usersId,
    ).then((value) async {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (value['value'] == 1) {
        await Pref().remove();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
        notifyListeners();
      } else {
        CustomDialog.messageResponse(
          context,
          value['message'] ?? "Logout gagal",
        );
        notifyListeners();
      }
    }).catchError((e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      CustomDialog.messageResponse(context, e.toString());
      notifyListeners();
    });
  }

  TextEditingController passLama = TextEditingController();
  TextEditingController passBaru = TextEditingController();
  TextEditingController confirmpassBaru = TextEditingController();
  TextEditingController passC = TextEditingController();
  gantipassword() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              child: Form(
                key: passForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text("Ganti Password")),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Password Lama",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextFormField(
                      controller: passLama,
                      // obscureText: true,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "wajib diisi";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(hintText: "Password Lama", errorText: ""),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Password Baru",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passBaru,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "wajib diisi";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(hintText: "Password Baru", errorText: ""),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Konfirmasi Password Baru",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passC,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "wajib diisi";
                        } else {
                          if (passBaru.text.trim() != passC.text.trim()) {
                            return "Konfirmasi password harus sama";
                          } else {
                            return null;
                          }
                        }
                      },
                      decoration: const InputDecoration(hintText: "Konfirmasi Password Baru", errorText: ""),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonPrimary(
                      onTap: () {
                        // Navigator.pop(context);
                        confirmPass();
                      },
                      name: "Ganti Sekarang",
                    )
                  ],
                ),
              ),
            ),
          );
        });
    notifyListeners();
  }

  var isLoading = false;
  Future confirmPass() async {
    if (passForm.currentState!.validate()) {
      var passwordBaru = passBaru.text.trim();
      var passwordLama = passLama.text.trim();
      var passwordNC = passC.text.trim();
      DialogCustom().showLoading(context);
      notifyListeners();
      AuthRepository.gantiPassword(token, NetworkURL.gantipassword(), users!.bprId, users!.usersId, encryptString(passwordBaru),
              encryptString(passwordLama), passwordNC, users!.usersId)
          .then((value) {
        Navigator.pop(context);
        if (value['value'] == 1) {
          Navigator.pop(context);
          passBaru.clear();
          passLama.clear();
          passC.clear();
          informationDialog(context, "Informasi", value['message']);
          notifyListeners();
        } else {
          informationDialog(context, "Informasi", value['message']);
          notifyListeners();
        }
      });
    }
  }

  Future<void> autoLogoutByIdle() async {
    if (_isAutoLoggingOut) return;
    _isAutoLoggingOut = true;

    try {
      if (users != null) {
        await AuthRepository.logOut(
          NetworkURL.logout(),
          users!.bprId,
          users!.usersId,
          users!.usersId,
        );
      }
    } catch (e) {
      debugPrint("AUTO LOGOUT ERROR: $e");
    }

    await Pref().remove();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );

      CustomDialog.messageResponse(
        context,
        "Sesi berakhir karena tidak ada aktivitas.",
      );
    }

    _isAutoLoggingOut = false;
  }

  Future<void> initBrowserCloseHandler() async {
    if (!kIsWeb) return;

    if (_browserCloseRegistered) return;

    _browserCloseRegistered = true;

    await registerBrowserCloseHandler(() async {
      await logoutFromBrowserClose();
    });
  }

  Future<void> logoutFromBrowserClose() async {
    if (_browserClosing) return;

    _browserClosing = true;

    try {
      await Pref().setLastActivityNow();
    } catch (e) {
      debugPrint("SAVE LAST ACTIVITY ON CLOSE ERROR: $e");
    }

    _browserClosing = false;
  }
}
