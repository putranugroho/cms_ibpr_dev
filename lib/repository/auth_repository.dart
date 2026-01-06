import 'dart:convert';

import 'package:cms_ibpr/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class AuthRepository {
  static Future<dynamic> login(
    String token,
    String url,
    String username,
    String password,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "userid": username,
      "userlogin": username,
      "password": password,
    };
    print("ini request login = ${jsonEncode(json)}");
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

  static Future<dynamic> logOut(String url, String bprId, String userlogin,
      String userid, String password, String sbbTeller) async {
    Map<String, dynamic> formData = {
      'userlogin': userlogin,
      'bpr_id': bprId,
      'term': "",
      'userid': userid,
      'password': encryptString(password),
      'sbbTeller': sbbTeller
    };
    Dio dio = Dio();
    print(jsonEncode(formData));
    dio.options.headers['Content-Type'] = "application/json";
    // dio.options.headers['x-api-key'] = apiKey;

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

  static Future<dynamic> inqueryHp(
    String token,
    String url,
    String bprId,
    String noHp,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "bpr_id": bprId,
      "no_hp": noHp,
    };
    print("ini body inquery = ${jsonEncode(json)}");
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

  static Future<dynamic> mPinGeneratedValidated(
    String token,
    String url,
    String bprId,
    String mpin,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      // "no_rek": noRek,
      "m_pin": mpin,
      // "bpr_id": bprId,
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
    print(formData.fields);
    Dio dio = Dio();
    dio.options.headers['x-username'] = xusername;
    dio.options.headers['x-password'] = xpassword;
    print("ENDPOINT URL : $url");
    if (kDebugMode) {}
    final response = await dio.post(url, data: formData);
    print("RESPONSE STATUS CODE : ${response.statusCode}");
    if (kDebugMode) {}
    if (response.statusCode == 200) {
      print("RESPONSE DATA LOGIN : ${response.data}");
      if (kDebugMode) {}
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
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "bpr_id": bprId,
      "no_hp": noHp,
      "no_rek": noRek,
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
    print(formData.fields);
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

  static Future<dynamic> generatedMPIN(
    String token,
    String url,
    String username,
    String kdKantor,
    String bprId,
    String noHp,
    String noRek,
    String mpin,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "term": "",
      "userlogin": username,
      "data": {
        "no_hp": noHp,
        "no_rek": noRek,
        "mpin": mpin,
      }
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
      "token": token,
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "term": "",
      "userlogin": username,
      "data": {
        "no_hp": noHp,
        "no_rek": noRek,
      }
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
    print(formData.fields);
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
}
