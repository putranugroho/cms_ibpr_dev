import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class NasabahRepository {
  static Dio _dio() {
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    return dio;
  }

  static dynamic _decode(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

  static Map<String, dynamic> _mapGoResponse(dynamic res) {
    final decoded = _decode(res);
    return {
      "value": decoded['code'] == "000" ? 1 : 0,
      "message": decoded['message'],
      "data": decoded['data'],
    };
  }

  static Uri _cleanUri(String url) {
    final uri = Uri.parse(url);
    return uri.replace(queryParameters: {});
  }

  static String _actionFromUrl(String url, String fallback) {
    final uri = Uri.parse(url);
    return uri.queryParameters['action'] ?? fallback;
  }

  static Future<dynamic> getNasabah(
    String token,
    String url,
    String username,
    String bprId,
    String kdKantor,
  ) async {
    Map<String, dynamic> json = {
      "type": "all",
      "userlogin": username,
      "bpr_id": bprId,
      "term": "web",
    };

    if (kDebugMode) {
      print("REQUEST GET NASABAH : $json");
    }

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }

    final response = await dio.post(url, data: json);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }

    return _mapGoResponse(response.data);
  }

  static Future<dynamic> getFotoNasabah(
    String token,
    String url,
    String bprId,
    int limit,
    int offset,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "bpr_id": bprId,
      "limit": limit,
      "offset": offset,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }
    return _decode(response.data);
  }

  static Future<dynamic> rejectedFotoCollme(
    String token,
    String url,
    String id,
    String alasan,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "id": id,
      "alasan": alasan,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }
    return _decode(response.data);
  }

  static Future<dynamic> approveFotoCollme(
    String token,
    String url,
    String id,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "id": id,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }
    return _decode(response.data);
  }

  static Future<dynamic> inqueryRekCMS(
    String token,
    String url,
    String username,
    String bprId,
    String trxCode,
    String trxType,
    String tglTrans,
    String tglTransmis,
    String rrn,
    String noRek,
    String glJns,
  ) async {
    Map<String, dynamic> json = {
      "userlogin": username,
      "bpr_id": bprId,
      "trx_code": trxCode,
      "trx_type": trxType,
      "tgl_trans": tglTrans,
      "tgl_transmis": tglTransmis,
      "rrn": rrn,
      "no_rek": noRek,
      "gl_jns": glJns,
    };

    if (kDebugMode) {
      print("REQUEST INQUIRY REKENING : ${jsonEncode(json)}");
    }

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }

    final response = await dio.post(url, data: json);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }

    return _mapGoResponse(response.data);
  }

  static Future<dynamic> blokirAkunCMS(
    String token,
    String url,
    String username,
    String bprId,
    String noHp,
    String noRek,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "userlogin": username,
      "no_hp": noHp,
      "no_rek": noRek,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }
    return _decode(response.data);
  }

  static Future<dynamic> insertGallery(
    String token,
    String url,
    Uint8List ktp,
    String ktpName,
    Uint8List selfiktp,
    String selfiktpName,
  ) async {
    FormData formData = FormData.fromMap({
      "selfiktp": MultipartFile.fromBytes(selfiktp, filename: selfiktpName),
      "ktp": MultipartFile.fromBytes(ktp, filename: ktpName),
    });

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }

    final response = await dio.post(url, data: formData);
    final decoded = _decode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : $decoded");
    }

    return {
      "value": decoded['code'] == "000" ? 1 : 0,
      "message": decoded['message'],
      "data": decoded['data'],
    };
  }

  static Future<dynamic> insertAkunCMS(
    String token,
    String url,
    String username,
    String bprId,
    String kdKantor,
    String acctType,
    String gender,
    String tglLahir,
    String noHp,
    String namaRek,
    String noRek,
    String nama,
    String noKtp,
    String fhoto1,
    String fhoto2,
  ) async {
    final action = _actionFromUrl(url, "insert");
    final cleanUrl = _cleanUri(url).toString();

    Map<String, dynamic> json = {
      "action": action,
      "no_ktp": noKtp,
      "nama": nama,
      "no_rek": noRek,
      "nama_rek": namaRek,
      "no_hp": noHp,
      "tgl_lahir": tglLahir,
      "gender": gender,
      "acct_type": acctType,
      "term": "web",
      "kd_kantor": kdKantor,
      "userlogin": username,
      "fhoto_1": fhoto1,
      "fhoto_2": fhoto2,
      "fhoto_3": fhoto1, // ✅ FIX
      "bpr_id": bprId,
    };

    Dio dio = _dio();
    final response = await dio.post(cleanUrl, data: json);

    return _mapGoResponse(response.data);
  }

  static Future<dynamic> updateAkunCMS(
    String token,
    String url,
    String username,
    String bprId,
    String kdKantor,
    String acctType,
    String gender,
    String tglLahir,
    String noHp,
    String namaRek,
    String noRek,
    String nama,
    String noKtp,
    String fhoto1,
    String fhoto2,
    String noHpLama,
    String noRekLama,
  ) async {
    final action = _actionFromUrl(url, "update");
    final cleanUrl = _cleanUri(url).toString();

    Map<String, dynamic> json = {
      "action": action,
      "no_ktp": noKtp,
      "nama": nama,
      "no_rek": noRek,
      "no_rek_lama": noRekLama,
      "nama_rek": namaRek,
      "no_hp": noHp,
      "no_hp_lama": noHpLama,
      "tgl_lahir": tglLahir,
      "gender": gender,
      "acct_type": acctType,
      "term": "web",
      "kd_kantor": kdKantor,
      "userlogin": username,
      "fhoto_1": fhoto1,
      "fhoto_2": fhoto2,
      "fhoto_3": "",
      "bpr_id": bprId,
    };

    if (kDebugMode) {
      print("ENDPOINT URL : $cleanUrl");
      print("REQUEST BODY : $json");
    }

    Dio dio = _dio();
    final response = await dio.post(cleanUrl, data: json);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }

    return _mapGoResponse(response.data);
  }

  static Future<dynamic> generatedMpin(
    String token,
    String url,
    String kdKantor,
    String bprId,
    String userslogin,
    String noHp,
    String noRek,
  ) async {
    Map<String, dynamic> json = {
      "userlogin": userslogin,
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "term": "web",
      "data": {
        "no_hp": noHp,
        "no_rek": noRek,
      }
    };

    if (kDebugMode) {
      print("REQUEST GENERATED MPIN : ${jsonEncode(json)}");
    }

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }

    final response = await dio.post(url, data: json);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : ${response.data}");
    }

    return _mapGoResponse(response.data);
  }

  static Future<dynamic> resetPasswordNasabah(
    String token,
    String url,
    String usersId,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "users_id": usersId.trim(),
      "bpr_id": bprId,
      "reset_attempt": true,
      "unlock_user": true,
    };

    Dio dio = _dio();
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST RESET PASSWORD NASABAH : $json");
    }

    final response = await dio.post(url, data: json);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA RESET PASSWORD NASABAH : ${response.data}");
    }

    return _mapGoResponse(response.data);
  }
}
