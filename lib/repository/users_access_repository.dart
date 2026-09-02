import 'dart:convert';

import 'package:cms_ibpr/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../network/network.dart';
import 'kantor_repository.dart';

class UsersAccessRepository {
  static Dio _dio() {
    Dio dio = Dio();
    dio.options.headers['api-key'] = apiKey;
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
    Map<String, dynamic> fasilitasJson = {"action": "list", "type": "CMS"};

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

    List<dynamic> kantor = [];
    try {
      final kantorResponse = await KantorRepository.getKantor(
        token,
        NetworkURL.getListKantorAccess(),
        username,
        bprId,
      );
      kantor = kantorResponse['data'] ?? [];
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

  static Future<dynamic> inquiryEmployee(
    String url,
    String bprId,
    String search,
  ) async {
    final body = {
      'bpr_id': bprId,
      'search': search.trim(),
      'page': '1',
      'limit': '100',
    };

    final response = await _dio().post(url, data: body);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print('ENDPOINT URL INQUIRY EMPLOYEE : $url');
      print('REQUEST INQUIRY EMPLOYEE : $body');
      print('RESPONSE INQUIRY EMPLOYEE : $decoded');
    }

    final rawHris = decoded is Map ? decoded['data'] : null;
    final nested = rawHris is Map ? rawHris['data'] : null;
    final employees = nested is Map && nested['employees'] is List
        ? List<dynamic>.from(nested['employees'])
        : <dynamic>[];
    final success = decoded is Map &&
        (decoded['code'] ?? '').toString() == '000' &&
        !(rawHris is Map && rawHris['success'] == false);

    return {
      'value': success ? 1 : 0,
      'message': decoded is Map
          ? (decoded['message'] ?? '').toString()
          : 'Response inquiry employee tidak valid',
      'data': employees,
      'raw': decoded,
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

  static Future<dynamic> forceLogoutUser(
    String url,
    String bprId,
    String userlogin,
    String userid,
  ) async {
    final Map<String, dynamic> json = {
      "bpr_id": bprId,
      "userlogin": _normalizeUpper(userlogin),
      "userid": _normalizeUpper(userid),
      "stsaktif": "N",
    };

    Dio dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL FORCE LOGOUT USER : $url");
      print("REQUEST FORCE LOGOUT USER : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE FORCE LOGOUT USER : ${response.statusCode}");
      print("RESPONSE DATA FORCE LOGOUT USER : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'],
      "raw": decoded,
    };
  }

  static Future<dynamic> unblockUserId(
    String url,
    String bprId,
    String userlogin,
    String userid,
  ) async {
    final Map<String, dynamic> json = {
      "bpr_id": bprId,
      "userlogin": _normalizeUpper(userlogin),
      "userid": _normalizeUpper(userid),
      "term": "WEB",
    };

    Dio dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL UNBLOCK USER ID : $url");
      print("REQUEST UNBLOCK USER ID : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE UNBLOCK USER ID : ${response.statusCode}");
      print("RESPONSE DATA UNBLOCK USER ID : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'],
      "raw": decoded,
    };
  }

  static Future<dynamic> resetDeviceUserId(
    String url,
    String bprId,
    String userlogin,
    String userid,
  ) async {
    final body = {
      'bpr_id': bprId,
      'userlogin': _normalizeUpper(userlogin),
      'userid': _normalizeUpper(userid),
    };

    final response = await _dio().post(url, data: body);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print('ENDPOINT URL RESET DEVICE : $url');
      print('REQUEST RESET DEVICE : $body');
      print('RESPONSE RESET DEVICE : $decoded');
    }

    return {
      'value': _mapValueFromGo(decoded),
      'message': _mapMessageFromGo(decoded),
      'data': decoded['data'],
      'raw': decoded,
    };
  }

  static Future<dynamic> deleteUsersId(
    String token,
    String url,
    String bprId,
    String usersId,
    String useridDelete,
    String password,
    String namaUsers,
    String kdkantor,
    String tglexp,
    String lvluser,
    String fasilitas,
  ) async {
    final List<dynamic> fasilitasRaw = fasilitas.trim().isEmpty ? [] : jsonDecode(fasilitas);

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
      "action": "delete",
      "bpr_id": bprId,
      "userlogin": _normalizeUpper(usersId),
      "userid": _normalizeUpper(useridDelete),
      "pass": encryptString(password),
      "namauser": _normalizeUpper(namaUsers),
      "kdkantor": kdkantor,
      "tglexp": _normalizeTglExpToGo(tglexp),
      "lvluser": lvluser,
      "fasilitas": fasilitasMapped,
    };

    Dio dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL DELETE USER : $url");
      print("REQUEST BODY DELETE USER : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE DELETE USER : ${response.statusCode}");
      print("RESPONSE DATA DELETE USER : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'],
    };
  }
}
