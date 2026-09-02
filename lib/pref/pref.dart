import 'dart:math';

import 'package:cms_ibpr/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static const Duration idleDuration = Duration(minutes: 5);

  static String bprId = "bpr_id";
  static String usersId = "users_id";
  static String namaUsers = "nama_users";
  static String kodeKantor = "kode_kantor";
  static String namaKantor = "nama_kantor";
  static String fasilitas = "fasilitas";
  static String deviceId = "cms_device_id";

  Future<String> getOrCreateDeviceId() async {
    final pref = await SharedPreferences.getInstance();
    final saved = (pref.getString(Pref.deviceId) ?? "").trim();
    if (saved.isNotEmpty) return saved;

    Random random;
    try {
      random = Random.secure();
    } catch (_) {
      random = Random();
    }

    final randomPart = List.generate(
      4,
      (_) => random.nextInt(0x100000000).toRadixString(16).padLeft(8, '0'),
    ).join();
    final generated = "CMS-${DateTime.now().microsecondsSinceEpoch}-$randomPart";

    await pref.setString(Pref.deviceId, generated);
    return generated;
  }

  simpan(UsersModel users) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Pref.bprId, users.bprId);
    pref.setString(Pref.usersId, users.usersId);
    pref.setString(Pref.namaUsers, users.namaUsers);
    pref.setString(Pref.kodeKantor, users.kodeKantor);
    pref.setString(Pref.namaKantor, users.namaKantor);
    pref.setInt(Pref.lastActivityAt, DateTime.now().millisecondsSinceEpoch);
  }

  Future<String> getFasilitas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String fasilitas = pref.getString(Pref.fasilitas) ?? "[]";
    return fasilitas;
  }

  setFasilitas(String fasilitas) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Pref.fasilitas, fasilitas);
  }

  Future<UsersModel> getUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UsersModel users = UsersModel(
        bprId: pref.getString(Pref.bprId) ?? "",
        usersId: pref.getString(Pref.usersId) ?? "",
        namaUsers: pref.getString(Pref.namaUsers) ?? "",
        kodeKantor: pref.getString(Pref.kodeKantor) ?? "",
        namaKantor: pref.getString(Pref.namaKantor) ?? "");
    return users;
  }

  remove() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Pref.bprId);
    pref.remove(Pref.usersId);
    pref.remove(Pref.namaUsers);
    pref.remove(Pref.kodeKantor);
    pref.remove(Pref.namaKantor);
    pref.remove(Pref.fasilitas);
    pref.remove(Pref.lastActivityAt);
    // deviceId sengaja tidak dihapus. ID ini mengikat instalasi/browser
    // yang sama meskipun user logout atau session berakhir.
  }

  static String lastActivityAt = "last_activity_at";

  Future<void> setLastActivityNow() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(Pref.lastActivityAt, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> isSessionExpired(Duration idleDuration) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final lastActivity = pref.getInt(Pref.lastActivityAt);

    if (lastActivity == null) return false;

    final last = DateTime.fromMillisecondsSinceEpoch(lastActivity);
    final diff = DateTime.now().difference(last);

    return diff >= idleDuration;
  }
}
