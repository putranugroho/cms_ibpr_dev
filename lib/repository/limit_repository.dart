import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class LimitRepository {
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

  static int _toInt(dynamic value) {
    final raw = (value ?? "0").toString();
    final clean = raw.replaceAll(",", "").replaceAll(".", "").trim();
    return int.tryParse(clean) ?? 0;
  }

  static int _mapValueFromGo(dynamic response) {
    final code = (response['code'] ?? '').toString();
    return code == "000" ? 1 : 0;
  }

  static String _mapMessageFromGo(dynamic response) {
    return (response['message'] ?? '').toString();
  }

  static List<dynamic> _mapDataList(dynamic response) {
    final data = response['data'];
    if (data is List) return data;
    if (data is Map<String, dynamic>) return [data];
    return [];
  }

  static List<dynamic> _mapLimitHarianToOldShape(List<dynamic> rows) {
    return rows.map((item) {
      final row = Map<String, dynamic>.from(item);
      return {
        // field Go asli tetap disimpan
        ...row,

        // field lama yang dipakai model/page Flutter
        "acctType": (row["acct_type"] ?? "").toString(),
        "description": (row["description"] ?? "").toString(),
        "trkTunaiHarian": (row["tarik_tunai"] ?? 0).toString(),
        "setorHarian": (row["setor"] ?? 0).toString(),
        "trfHarian": (row["transfer"] ?? 0).toString(),
        "qrHarian": (row["qr"] ?? 0).toString(),
        "ppobHarian": (row["ppob"] ?? 0).toString(),
      };
    }).toList();
  }

  static List<dynamic> _mapLimitTrxToOldShape(List<dynamic> rows) {
    return rows.map((item) {
      final row = Map<String, dynamic>.from(item);
      return {
        // field Go asli tetap disimpan
        ...row,

        // field lama yang dipakai model/page Flutter
        "acctType": (row["acct_type"] ?? "").toString(),
        "description": (row["description"] ?? "").toString(),
        "trkTunaiTrx": (row["tarik_tunai"] ?? 0).toString(),
        "setorTrx": (row["setor"] ?? 0).toString(),
        "trfTrx": (row["transfer"] ?? 0).toString(),
        "qrTrx": (row["qr"] ?? 0).toString(),
        "ppobTrx": (row["ppob"] ?? 0).toString(),
      };
    }).toList();
  }

  static Future<dynamic> getLimitHarian(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    final json = {
      "action": "list",
      "type": "limitharian",
      "userlogin": username,
      "bpr_id": bprId,
      "term": "web",
    };

    Dio dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL LIMIT HARIAN : $url");
      print("REQUEST BODY LIMIT HARIAN : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);
    final mappedRows = _mapLimitHarianToOldShape(_mapDataList(decoded));

    if (kDebugMode) {
      print("RESPONSE STATUS CODE LIMIT HARIAN : ${response.statusCode}");
      print("RESPONSE DATA LIMIT HARIAN RAW : $decoded");
      print("RESPONSE DATA LIMIT HARIAN MAPPED : $mappedRows");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": mappedRows,
      "raw": decoded,
    };
  }

  static Future<dynamic> getLimitTrx(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    final json = {
      "action": "list",
      "type": "limittrx",
      "userlogin": username,
      "bpr_id": bprId,
      "term": "web",
    };

    Dio dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT URL LIMIT TRX : $url");
      print("REQUEST BODY LIMIT TRX : $json");
    }

    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);
    final mappedRows = _mapLimitTrxToOldShape(_mapDataList(decoded));

    if (kDebugMode) {
      print("RESPONSE STATUS CODE LIMIT TRX : ${response.statusCode}");
      print("RESPONSE DATA LIMIT TRX RAW : $decoded");
      print("RESPONSE DATA LIMIT TRX MAPPED : $mappedRows");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": mappedRows,
      "raw": decoded,
    };
  }

  static Future<dynamic> insertLimitHarian(
    String token,
    String url,
    String bprId,
    String username,
    String limitHarian,
  ) async {
    final List<dynamic> rawLimit = jsonDecode(limitHarian);

    final List<Map<String, dynamic>> mappedLimit = rawLimit.map((e) {
      final row = Map<String, dynamic>.from(e);

      return {
        "tarik_tunai": _toInt(row["trkTunaiHarian"] ?? row["tarik_tunai"]),
        "setor": _toInt(row["setorHarian"] ?? row["setor"]),
        "transfer": _toInt(row["trfHarian"] ?? row["transfer"]),
        "qr": _toInt(row["qrHarian"] ?? row["qr"]),
        "ppob": _toInt(row["ppobHarian"] ?? row["ppob"]),
        "acct_type": (row["acctType"] ?? row["acct_type"] ?? "").toString(),
      };
    }).toList();

    final json = {
      "action": "insert",
      "type": "limitharian",
      "userlogin": username,
      "bpr_id": bprId,
      "limit": mappedLimit,
    };

    final dio = _dio();
    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded["data"],
      "raw": decoded,
    };
  }

  static Future<dynamic> insertLimitTrx(
    String token,
    String url,
    String bprId,
    String username,
    String limitTrx,
  ) async {
    final List<dynamic> rawLimit = jsonDecode(limitTrx);

    final List<Map<String, dynamic>> mappedLimit = rawLimit.map((e) {
      final row = Map<String, dynamic>.from(e);

      return {
        "tarik_tunai": _toInt(row["trkTunaiTrx"] ?? row["tarik_tunai"]),
        "setor": _toInt(row["setorTrx"] ?? row["setor"]),
        "transfer": _toInt(row["trfTrx"] ?? row["transfer"]),
        "qr": _toInt(row["qrTrx"] ?? row["qr"]),
        "ppob": _toInt(row["ppobTrx"] ?? row["ppob"]),
        "acct_type": (row["acctType"] ?? row["acct_type"] ?? "").toString(),
      };
    }).toList();

    final json = {
      "action": "insert",
      "type": "limittrx",
      "userlogin": username,
      "bpr_id": bprId,
      "limit": mappedLimit,
    };

    final dio = _dio();
    final response = await dio.post(url, data: json);
    final decoded = _safeDecode(response.data);

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded["data"],
      "raw": decoded,
    };
  }
}
