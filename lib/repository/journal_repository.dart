import 'dart:convert';

import 'package:cms_ibpr/module/journal/setup_journal_transaksi_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class JournalRepository {
  static Dio _dio() {
    final dio = Dio();
    dio.options.headers = {
      "Content-Type": "application/json",
      "x-username": xusername,
      "x-password": xpassword,
    };
    return dio;
  }

  static dynamic _decode(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

  static Map<String, dynamic> _mapGoResponse(dynamic response) {
    final decoded = _decode(response);
    return {
      "value": (decoded['code'] ?? '').toString() == "000" ? 1 : 0,
      "message": (decoded['message'] ?? '').toString(),
      "data": decoded['data'],
      "raw": decoded,
    };
  }

  // Asumsi sementara:
  // GL = 1
  // Rekening / Rekening Nasabah / Rekening MTD = 2
  static String _mapJenisSbb(String text) {
    final value = text.trim().toLowerCase();
    if (value == "gl") return "1";
    return "2";
  }

  static Future<dynamic> saveSetupTransaksi(
    String url,
    String userlogin,
    String bprId,
    String term,
    String kdKantor,
    String tcode,
    String ketTcode,
    List<JournalItemModel> journals,
  ) async {
    final data = journals.map((e) {
      return {
        "tcode": tcode,
        "jns_gl": e.jnsGl,
        "nosbb_db": e.useNasabahDebit ? "" : e.debitNoRek.text.trim(),
        "nmsbb_db": e.useNasabahDebit ? "" : e.debitNamaRek.text.trim(),
        "jns_sbb_db": _mapJenisSbb(e.jenisSbbDebitController.text),
        "nosbb_cr": e.useNasabahKredit ? "" : e.kreditNoRek.text.trim(),
        "nmsbb_cr": e.useNasabahKredit ? "" : e.kreditNamaRek.text.trim(),
        "jns_sbb_cr": _mapJenisSbb(e.jenisSbbKreditController.text),
        "ket_tcode": ketTcode,
      };
    }).toList();

    final body = {
      "userlogin": userlogin,
      "bpr_id": bprId,
      "term": term,
      "kd_kantor": kdKantor,
      "data": data,
    };

    if (kDebugMode) {
      print("ENDPOINT URL SETUP TRANSAKSI : $url");
      print("REQUEST SETUP TRANSAKSI : $body");
    }

    final response = await _dio().post(url, data: body);
    final mapped = _mapGoResponse(response.data);

    if (kDebugMode) {
      print("RESPONSE STATUS CODE SETUP TRANSAKSI : ${response.statusCode}");
      print("RESPONSE DATA SETUP TRANSAKSI : ${mapped['raw']}");
    }

    return mapped;
  }
}
