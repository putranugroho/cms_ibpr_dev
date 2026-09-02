import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/repository/kantor_repository.dart';
import 'package:flutter/material.dart';

import '../../network/network.dart';

class KantorNotifier extends ChangeNotifier {
  KantorNotifier({required this.context}) {
    getProfile();
  }

  final BuildContext context;
  UsersModel? users;
  bool isLoading = true;
  String errorMessage = '';
  final List<KantorModel> list = [];

  Future<void> getProfile() async {
    users = await Pref().getUsers();
    await getKantor();
  }

  Future<void> getKantor() async {
    if (users == null) return;

    isLoading = true;
    errorMessage = '';
    list.clear();
    notifyListeners();

    try {
      final value = await KantorRepository.getKantor(
        token,
        NetworkURL.getListKantorAccess(),
        users!.usersId,
        users!.bprId,
      );

      if (value['value'] == 1) {
        final rawData = value['data'];
        if (rawData is List) {
          for (final raw in rawData) {
            if (raw is Map) {
              list.add(KantorModel.fromJson(Map<String, dynamic>.from(raw)));
            }
          }
        }
      } else {
        errorMessage = (value['message'] ?? 'Gagal mengambil data kantor HRIS').toString();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
