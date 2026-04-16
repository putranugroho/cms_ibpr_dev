import 'dart:convert';

import 'package:cms_ibpr/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class AuthRepository {
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

  static Map<String, dynamic> _mapLoginDataToOldShape(
    Map<String, dynamic> row,
    String bprId,
  ) {
    return {
      // shape lama yang biasa dipakai frontend / UsersModel
      "users_id": (row["Userid"] ?? "").toString(),
      "usersId": (row["Userid"] ?? "").toString(),
      "userid": (row["Userid"] ?? "").toString(),

      "nama_users": (row["Namauser"] ?? "").toString(),
      "namaUsers": (row["Namauser"] ?? "").toString(),
      "namauser": (row["Namauser"] ?? "").toString(),

      "bpr_id": bprId,
      "bprId": bprId,

      "kode_kantor": (row["Kdkantor"] ?? "").toString(),
      "kodeKantor": (row["Kdkantor"] ?? "").toString(),
      "kdkantor": (row["Kdkantor"] ?? "").toString(),

      "kode_bank": (row["Kdbank"] ?? "").toString(),
      "kodeBank": (row["Kdbank"] ?? "").toString(),
      "kdbank": (row["Kdbank"] ?? "").toString(),

      "pass": (row["Pass"] ?? "").toString(),
      "tglexp": (row["Tglexp"] ?? "").toString(),
      "lvluser": (row["Lvluser"] ?? "").toString(),
      "nama_kantor": (row["NamaKantor"] ?? "").toString(),

      // raw response Go tetap disimpan supaya field lain masih bisa dipakai
      ...row,
    };
  }

  static Future<dynamic> login(
    String token,
    String url,
    String username,
    String password,
  ) async {
    const String bprId = "609999";

    final normalizedUserId = _normalizeUpper(username);

    Map<String, dynamic> json = {
      "bpr_id": bprId,
      "userlogin": "ADMIN",
      "userid": normalizedUserId,
      "password": encryptString(password.trim()),
    };

    final dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL LOGIN : $url");
      print("REQUEST LOGIN : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE LOGIN : ${response.statusCode}");
      print("RESPONSE DATA LOGIN : $decoded");
    }

    final rawData = decoded['data'];
    final mappedData = rawData is Map<String, dynamic> ? _mapLoginDataToOldShape(rawData, bprId) : <String, dynamic>{};

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": mappedData,
      "fasilitas": <dynamic>[],
      "raw": decoded,
    };
  }

  static Future<dynamic> logOut(
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

    final dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL LOGOUT : $url");
      print("REQUEST LOGOUT : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE LOGOUT : ${response.statusCode}");
      print("RESPONSE DATA LOGOUT : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'],
      "raw": decoded,
    };
  }

  static Future<dynamic> inqueryHp(
    String token,
    String url,
    String bprId,
    String noHp,
    String userlogin,
  ) async {
    Map<String, dynamic> json = {
      "type": "byhp",
      "userlogin": userlogin,
      "bpr_id": bprId,
      "no_hp": noHp,
      "term": "web",
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST INQUIRY HP : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = response.data is String ? jsonDecode(response.data) : response.data;

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

  static Future<dynamic> inquiryUserAccount(
    String token,
    String url,
    String bprId,
    String usersId,
  ) async {
    Map<String, dynamic> json = {
      "users_id": usersId.trim(),
      "bpr_id": bprId,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST INQUIRY USER ACCOUNT : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE DATA INQUIRY USER ACCOUNT : $decoded");
    }

    return {
      "value": decoded['code'] == "000" ? 1 : 0,
      "message": decoded['message'],
      "data": decoded['data'],
    };
  }

  static Future<dynamic> postJson(
    String url,
    Map<String, dynamic> body,
  ) async {
    final dio = Dio();

    dio.options.headers = {
      "Content-Type": "application/json",
      "x-username": xusername,
      "x-password": xpassword,
    };

    final response = await dio.post(
      url,
      data: body,
    );

    return response.data is String ? jsonDecode(response.data) : response.data;
  }

  static Future<dynamic> createUsersInfo(
    String url,
    Map<String, dynamic> body,
  ) async {
    Dio dio = Dio();

    dio.options.headers = {
      'x-username': xusername,
      'x-password': xpassword,
    };

    final res = await dio.post(
      url,
      data: FormData.fromMap(body),
    );

    return res.data is String ? jsonDecode(res.data) : res.data;
  }

  static Future<dynamic> mPinGeneratedValidated(
    String token,
    String url,
    String bprId,
    String mpin,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "m_pin": mpin,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: formData);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("RESPONSE DATA LOGIN : ${response.data}");
      }
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> getUsersInfoList(
    String token,
    String url,
    String bprId, {
    String? search,
    String? page,
    String? limit,
  }) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "bpr_id": bprId,
      if (search != null) "search": search,
      if (page != null) "page": page,
      if (limit != null) "limit": limit,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: formData);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("RESPONSE DATA LOGIN : ${response.data}");
      }
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> validateCard(
    String token,
    String url,
    String noRek,
    String uniqId,
    String bprId,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "no_rek": noRek,
      "uniq_id": uniqId,
      "bpr_id": bprId,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: formData);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("RESPONSE DATA LOGIN : ${response.data}");
      }
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> inqueryMpinDev(
    String token,
    String url,
    String noRek,
    String bprId,
    String mPin,
    String noHp,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "no_rek": noRek,
      "bpr_id": bprId,
      "m_pin": mPin,
      "no_hp": noHp,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: formData);
    if (kDebugMode) {
      print("RESPONSE STATUS CODE : ${response.statusCode}");
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("RESPONSE DATA LOGIN : ${response.data}");
      }
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> addCardNew(
    String token,
    String url,
    String uniqId,
    String noRek,
    String bprId,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "no_rek": noRek,
      "uniq_id": uniqId,
      "bpr_id": bprId,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> updateMpinCetak(
    String token,
    String url,
    String bprId,
    String noHp,
    String noRek,
    String userlogin,
    String kdKantor,
  ) async {
    Map<String, dynamic> json = {
      "userlogin": userlogin,
      "bpr_id": bprId,
      "term": "WEB",
      "kd_kantor": kdKantor,
      "no_rek": noRek,
      "no_hp": noHp,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    if (kDebugMode) {
      print("ENDPOINT URL : $url");
      print("REQUEST UPDATE CETAK MPIN : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = response.data is String ? jsonDecode(response.data) : response.data;

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

  static Future<dynamic> gantiMpinCMS(
    String token,
    String url,
    String idUsers,
    String bprId,
    String noHp,
    String noRek,
    String mPinLama,
    String mPinBaru,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "id_users": idUsers,
      "no_rek": noRek,
      "no_hp": noHp,
      "bpr_id": bprId,
      "mpin_lama": mPinLama,
      "mpin_baru": mPinBaru,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }

  static Future<dynamic> generatedMPIN(
    String token,
    String url,
    String userlogin,
    String kdKantor,
    String bprId,
    String noHp,
    String noRek,
  ) async {
    Map<String, dynamic> json = {
      "userlogin": userlogin,
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "term": "web",
      "data": {
        "no_hp": noHp,
        "no_rek": noRek,
      }
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    final response = await dio.post(url, data: json);
    final decoded = response.data is String ? jsonDecode(response.data) : response.data;

    return {
      "value": decoded['code'] == "000" ? 1 : 0,
      "message": decoded['message'],
      "data": decoded['data'],
    };
  }

  static Future<dynamic> regenerateMpinGo(
    String token,
    String url,
    String userlogin,
    String kdKantor,
    String bprId,
    String noHp,
    String noRek,
  ) async {
    Map<String, dynamic> json = {
      "userlogin": userlogin,
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "term": "web",
      "data": {
        "no_hp": noHp,
        "no_rek": noRek,
      }
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    final response = await dio.post(url, data: json);
    final decoded = response.data is String ? jsonDecode(response.data) : response.data;

    return {
      "value": decoded['code'] == "000" ? 1 : 0,
      "message": decoded['message'],
      "data": decoded['data'],
    };
  }

  static Future<dynamic> resetMpin(
    String token,
    String url,
    String username,
    String kdKantor,
    String bprId,
    String noHp,
    String noRek,
  ) async {
    Map<String, dynamic> json = {
      "userlogin": username,
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "term": "web",
      "data": {
        "no_hp": noHp,
        "no_rek": noRek,
      }
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;

    final response = await dio.post(url, data: json);
    final decoded = response.data is String ? jsonDecode(response.data) : response.data;

    return {
      "value": decoded['code'] == "000" ? 1 : 0,
      "message": decoded['message'],
      "data": decoded['data'],
    };
  }

  static Future<dynamic> gantiPassword(
    String token,
    String url,
    String bprId,
    String userid,
    String pass,
    String passLama,
    String passBaru,
    String userlogin,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "bprid": bprId,
      "userid": userid,
      "pass": pass,
      "pass_lama": passLama,
      "pass_c": passBaru,
      "userlogin": userlogin,
    });
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return jsonDecode(response.data);
    } else {
      return jsonDecode(response.data);
    }
  }
}
