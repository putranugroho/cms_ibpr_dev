import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class LimitRepository {
  static Future<dynamic> getLimitHarian(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      // "term": "",
      "userlogin": username,
      "bpr_id": bprId,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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

  static Future<dynamic> getLimitTrx(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      // "term": "",
      "userlogin": username,
      "bpr_id": bprId,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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

  static Future<dynamic> insertLimitHarian(
    String token,
    String url,
    String bprId,
    String username,
    String limitHarian,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "bpr_id": bprId,
      // "term": "",
      "userlogin": username,
      "limitharian": jsonDecode(limitHarian),
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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

  static Future<dynamic> insertAcctTYpe(
    String token,
    String url,
    String bprId,
    String username,
    String kdAcc,
    String keterangan,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      // "term": "",
      "bpr_id": bprId,
      "userlogin": username,
      "keterangan": keterangan,
      "kd_acc": kdAcc,
    };
    print(json);
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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

  static Future<dynamic> insertKantorCMS(
    String token,
    String url,
    String bprId,
    String userlogin,
    String kdBank,
    String kdKantor,
    String namaKantor,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "userlogin": userlogin,
      "kd_bank": kdBank,
      "kd_kantor": kdKantor,
      "nama_kantor": namaKantor,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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

  static Future<dynamic> updateKantorCMS(
    String token,
    String url,
    String bprId,
    String userlogin,
    String kdBank,
    String kdKantor,
    String namaKantor,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "userlogin": userlogin,
      "kd_bank": kdBank,
      "kd_kantor": kdKantor,
      "nama_kantor": namaKantor,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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

  static Future<dynamic> deleteKantorCMS(
    String token,
    String url,
    String bprId,
    String userlogin,
    String kdBank,
    String kdKantor,
    String namaKantor,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "userlogin": userlogin,
      "kd_bank": kdBank,
      "kd_kantor": kdKantor,
      "nama_kantor": namaKantor,
    };

    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    if (kDebugMode) {
      print("ENDPOINT URL : $url");
    }
    final response = await dio.post(url, data: json);
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
}
