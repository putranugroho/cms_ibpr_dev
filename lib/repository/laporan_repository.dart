import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class LaporanRepository {
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

  static Map<String, dynamic> _mapGoResponse(dynamic response) {
    final decoded = _safeDecode(response);
    if (decoded is! Map) {
      return {
        "value": 0,
        "message": "Format response tidak valid",
        "data": [],
      };
    }

    final map = Map<String, dynamic>.from(decoded);
    return {
      "value": (map["code"] ?? "").toString() == "000" ? 1 : 0,
      "message": (map["message"] ?? "").toString(),
      "data": map["data"] ?? [],
      "raw": map,
    };
  }

  static Future<dynamic> getUserAccessReport({
    required String url,
    required String username,
    required String bprId,
  }) async {
    final body = {
      "type": "all",
      "userlogin": username,
      "bpr_id": bprId,
    };

    final dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT LAPORAN USER ACCESS : $url");
      print("REQUEST LAPORAN USER ACCESS : $body");
    }

    final response = await dio.post(url, data: body);
    final mapped = _mapGoResponse(response.data);

    if (kDebugMode) {
      print("RESPONSE LAPORAN USER ACCESS : $mapped");
    }

    return mapped;
  }

  static Future<dynamic> getAkunIbprReport({
    required String url,
    required String username,
    required String bprId,
    required String kdKantor,
    required String status,
    required bool useTanggal,
    required String tanggal,
  }) async {
    final body = {
      "type": "all",
      "userlogin": username,
      "bpr_id": bprId,
      "term": "web",
      "kd_kantor": kdKantor,
      "status": status == "ALL" ? "" : status,
      "use_tgl": useTanggal ? "Y" : "N",
      "tgl_awal": useTanggal ? tanggal : "",
      "tgl_akhir": useTanggal ? tanggal : "",
    };

    final dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT LAPORAN AKUN IBPR : $url");
      print("REQUEST LAPORAN AKUN IBPR : $body");
    }

    final response = await dio.post(url, data: body);
    final mapped = _mapGoResponse(response.data);

    if (kDebugMode) {
      print("RESPONSE LAPORAN AKUN IBPR : $mapped");
    }

    return mapped;
  }

  static Future<dynamic> getTrxLogReport({
    required String url,
    required String username,
    required String bprId,
    required String keyword,
    required String tglAwal,
    required String tglAkhir,
    String trxCategory = "ALL",
    String status = "ALL",
    int limit = 500,
    int offset = 0,
  }) async {
    final body = {
      "action": "list",
      "userlogin": username,
      "bpr_id": bprId,
      "trx_category": trxCategory,
      "status": status,
      "keyword": keyword,
      "tgl_awal": tglAwal,
      "tgl_akhir": tglAkhir,
      "limit": limit,
      "offset": offset,
    };

    final dio = _dio();

    if (kDebugMode) {
      print("ENDPOINT LAPORAN TRANSAKSI : $url");
      print("REQUEST LAPORAN TRANSAKSI : $body");
    }

    final response = await dio.post(url, data: body);
    final mapped = _mapGoResponse(response.data);

    if (kDebugMode) {
      print("RESPONSE LAPORAN TRANSAKSI : $mapped");
    }

    return mapped;
  }
}
