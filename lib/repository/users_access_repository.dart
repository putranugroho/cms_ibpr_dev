import 'dart:convert';

import 'package:cms_ibpr/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../network/network.dart';

class UsersAccessRepository {
  static Dio _dio() {
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    return dio;
  }

  static dynamic _safeDecode(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

  static int _mapValueFromGo(dynamic response) {
    final code = (response['code'] ?? '').toString();
    return code == "000" ? 1 : 0;
  }

  static String _mapMessageFromGo(dynamic response) {
    return (response['message'] ?? '').toString();
  }

  static String _normalizeUpper(dynamic value) {
    return (value ?? "").toString().trim().toUpperCase();
  }

  static String _normalizeFlagToOld(dynamic value) {
    final v = (value ?? '').toString().toLowerCase();
    if (v == 'true') return 'TRUE';
    if (v == 'false') return 'FALSE';
    return value?.toString() ?? '';
  }

  static String _normalizeFlagToGo(dynamic value) {
    final v = (value ?? '').toString().toLowerCase();
    if (v == 'true') return 'True';
    if (v == 'false') return 'False';
    return value?.toString() ?? 'False';
  }

  static String _normalizeModulToGo(dynamic value) {
    final v = (value ?? '').toString();
    if (v.isEmpty) return 'CMS';
    return v.toUpperCase();
  }

  static String _normalizeTglExpToGo(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return raw;

    try {
      // sudah lengkap dengan jam
      if (raw.contains(':')) {
        final dt = DateTime.parse(raw.replaceFirst(' ', 'T'));
        return "${DateFormat("yyyy-MM-dd").format(dt)} 23:59:59";
      }

      // hanya tanggal
      final dt = DateFormat("yyyy-MM-dd").parse(raw);
      return "${DateFormat("yyyy-MM-dd").format(dt)} 23:59:59";
    } catch (_) {
      // fallback: kalau format tidak dikenali, kirim apa adanya
      return raw;
    }
  }

  static Future<dynamic> getUsersAccess(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "type": "all",
      "userlogin": username,
      "bpr_id": bprId,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST BODY : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'] ?? [],
    };
  }

  static Future<dynamic> getListFasilitas(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Dio dio = _dio();

    // fasilitas sekarang pakai endpoint yang sama dengan by user
    // supaya notifier lama tidak berubah, kita isi userid dengan user login
    Map<String, dynamic> fasilitasJson = {
      "userlogin": username,
      "bpr_id": bprId,
    };

    if (kDebugMode) {
      print("ENDPOINT URL FASILITAS : $url");
      print("REQUEST BODY FASILITAS : $fasilitasJson");
    }

    final fasilitasResponse = await dio.post(url, data: fasilitasJson);
    final fasilitasDecoded = _safeDecode(fasilitasResponse.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE FASILITAS : ${fasilitasResponse.statusCode}");
      print("RESPONSE DATA FASILITAS : $fasilitasDecoded");
    }

    List<dynamic> fasilitas = [];
    for (final item in (fasilitasDecoded['data'] ?? [])) {
      final row = Map<String, dynamic>.from(item);
      row['flag'] = _normalizeFlagToOld(row['flag']);
      fasilitas.add(row);
    }

    // kantor sekarang terpisah endpoint
    // response akhir tetap digabung supaya notifier lama tetap jalan
    List<dynamic> kantor = [];
    try {
      Map<String, dynamic> kantorJson = {"type": "all", "bpr_id": bprId, "userlogin": username, "term": "web"};

      if (kDebugMode) {
        print("ENDPOINT URL KANTOR : ${NetworkURL.getListKantorAccess()}");
        print("REQUEST BODY KANTOR : $kantorJson");
      }

      final kantorResponse = await dio.post(
        NetworkURL.getListKantorAccess(),
        data: kantorJson,
      );
      final kantorDecoded = _safeDecode(kantorResponse.data);

      if (kDebugMode) {
        print("RESPONSE STATUS CODE KANTOR : ${kantorResponse.statusCode}");
        print("RESPONSE DATA KANTOR : $kantorDecoded");
      }

      kantor = kantorDecoded['data'] ?? kantorDecoded['kantor'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("GET KANTOR ERROR : $e");
      }
    }

    return {
      "value": _mapValueFromGo(fasilitasDecoded),
      "message": _mapMessageFromGo(fasilitasDecoded),
      "data": fasilitas,
      "kantor": kantor,
    };
  }

  static Future<dynamic> getListFasilitasByUsers(
    String token,
    String url,
    String username,
    String userId,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "type": "byuserid",
      "userlogin": username,
      "userid": userId,
      "bpr_id": bprId,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST BODY : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : $decoded");
    }

    List<dynamic> mappedData = [];
    for (final item in (decoded['data'] ?? [])) {
      final row = Map<String, dynamic>.from(item);
      row['flag'] = _normalizeFlagToOld(row['flag']);
      mappedData.add(row);
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": mappedData,
    };
  }

  static Future<dynamic> insertUsersId(
    String token,
    String url,
    String action,
    String bprId,
    String usersId,
    String password,
    String username,
    String namaUsers,
    String kdkantor,
    String tglexp,
    String lvluser,
    String fasilitas,
  ) async {
    final List<dynamic> fasilitasRaw = jsonDecode(fasilitas);

    final List<Map<String, dynamic>> fasilitasMapped = fasilitasRaw.map((e) {
      final row = Map<String, dynamic>.from(e);
      return {
        "modul": _normalizeModulToGo(row['modul']),
        "menu": row['menu'],
        "submenu": row['submenu'],
        "subsubmenu": row['subsubmenu'],
        "urut": row['urut'],
        "flag": _normalizeFlagToGo(row['flag']),
      };
    }).toList();

    Map<String, dynamic> json = {
      "action": action,
      "bpr_id": bprId,
      "userlogin": _normalizeUpper(usersId),
      "userid": _normalizeUpper(username),
      "pass": encryptString(password),
      "namauser": _normalizeUpper(namaUsers),
      "kdkantor": kdkantor,
      "tglexp": _normalizeTglExpToGo(tglexp),
      "lvluser": lvluser,
      "fasilitas": fasilitasMapped,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST BODY : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'],
    };
  }
}
