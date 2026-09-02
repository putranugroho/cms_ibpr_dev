import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';
import 'kantor_repository.dart';

class AccountRepository {
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

  static List<dynamic> _mapDataList(dynamic response) {
    final data = response['data'];
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      return [data];
    }
    return [];
  }

  static Future<dynamic> getListAll(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Dio dio = _dio();

    final acctJson = {
      "type": "listall",
      "userlogin": username,
      "bpr_id": bprId,
      "term": "web",
    };

    if (kDebugMode) {
      print("ENDPOINT URL ACCTYPE : $url");
      print("REQUEST BODY ACCTYPE : $acctJson");
    }

    final acctResponse = await dio.post(url, data: acctJson);
    final acctDecoded = _safeDecode(acctResponse.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE ACCTYPE : ${acctResponse.statusCode}");
      print("RESPONSE DATA ACCTYPE : $acctDecoded");
    }

    // Kantor bersumber dari HRIS, melalui mapper yang dipakai halaman Kantor.
    List<dynamic> kantor = [];
    try {
      final kantorResponse = await KantorRepository.getKantor(
        token,
        NetworkURL.getListKantorAccess(),
        username,
        bprId,
      );
      kantor = List<dynamic>.from(kantorResponse['data'] ?? []);
    } catch (e) {
      if (kDebugMode) {
        print("GET KANTOR ERROR : $e");
      }
    }

    return {
      "value": _mapValueFromGo(acctDecoded),
      "message": _mapMessageFromGo(acctDecoded),
      "data": _mapDataList(acctDecoded),
      "kantor": kantor,
      "raw": acctDecoded,
    };
  }

  static Future<dynamic> saveAcctType(
    String token,
    String url,
    String action,
    String bprId,
    String username,
    String kdAcc,
    String keterangan,
  ) async {
    final json = {
      "action": action,
      "userlogin": username,
      "bpr_id": bprId,
      "kd_acc": kdAcc,
      "keterangan": keterangan,
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
      print("RESPONSE DATA ACCTYPE SAVE : $decoded");
    }

    return {
      "value": _mapValueFromGo(decoded),
      "message": _mapMessageFromGo(decoded),
      "data": decoded['data'],
      "raw": decoded,
    };
  }
}
