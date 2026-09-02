import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class KantorRepository {
  static Dio _dio() {
    final dio = Dio();
    dio.options.headers['api-key'] = apiKey;
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    return dio;
  }

  static dynamic _safeDecode(dynamic data) {
    if (data is String) return jsonDecode(data);
    return data;
  }

  static Map<String, dynamic> _hrisPayload(dynamic response) {
    if (response is! Map) return <String, dynamic>{};

    final outerData = response['data'];
    if (outerData is! Map) return <String, dynamic>{};

    final nestedData = outerData['data'];
    if (nestedData is Map) {
      return Map<String, dynamic>.from(nestedData);
    }

    return Map<String, dynamic>.from(outerData);
  }

  static bool _hrisSuccess(dynamic response) {
    if (response is! Map) return false;
    if ((response['code'] ?? '').toString() != '000') return false;

    final rawHris = response['data'];
    if (rawHris is Map && rawHris['success'] == false) return false;
    return true;
  }

  static Future<dynamic> getKantor(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    final dio = _dio();
    final offices = <Map<String, dynamic>>[];
    var page = 1;
    var totalPages = 1;
    var message = 'OK';

    do {
      final body = {
        'bpr_id': bprId,
        'page': page.toString(),
        'limit': '100',
      };

      if (kDebugMode) {
        print('ENDPOINT URL HRIS KANTOR : $url');
        print('REQUEST BODY HRIS KANTOR : $body');
      }

      final response = await dio.post(url, data: body);
      final decoded = _safeDecode(response.data);
      message = (decoded is Map ? decoded['message'] : null)?.toString() ?? '';

      if (!_hrisSuccess(decoded)) {
        return {
          'value': 0,
          'message': message.isEmpty ? 'Gagal mengambil data kantor HRIS' : message,
          'data': <dynamic>[],
          'raw': decoded,
        };
      }

      final payload = _hrisPayload(decoded);
      final bpr = payload['bpr'] is Map ? Map<String, dynamic>.from(payload['bpr']) : <String, dynamic>{};
      final bprCode = (bpr['code'] ?? bprId).toString();
      final rawOffices = payload['offices'];

      if (rawOffices is List) {
        for (final raw in rawOffices) {
          if (raw is! Map) continue;
          final office = Map<String, dynamic>.from(raw);
          office['bpr_id'] = bprCode;
          office['bpr_code'] = bprCode;
          office['kd_kantor'] = office['branch_code'];
          office['nama_kantor'] = office['name'];
          offices.add(office);
        }
      }

      final meta = payload['meta'];
      if (meta is Map) {
        totalPages = int.tryParse((meta['total_pages'] ?? 1).toString()) ?? 1;
      }
      page++;
    } while (page <= totalPages);

    return {
      'value': 1,
      'message': message,
      'data': offices,
      'sandi_bank': [
        {'kode_bank': bprId, 'nama': bprId}
      ],
    };
  }
}
