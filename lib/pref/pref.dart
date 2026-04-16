import 'package:cms_ibpr/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static String bprId = "bpr_id";
  static String usersId = "users_id";
  static String namaUsers = "nama_users";
  static String kodeKantor = "kode_kantor";
  static String namaKantor = "nama_kantor";
  static String fasilitas = "fasilitas";

  simpan(UsersModel users) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Pref.bprId, users.bprId);
    pref.setString(Pref.usersId, users.usersId);
    pref.setString(Pref.namaUsers, users.namaUsers);
    pref.setString(Pref.kodeKantor, users.kodeKantor);
    pref.setString(Pref.namaKantor, users.namaKantor);
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
  }
}
