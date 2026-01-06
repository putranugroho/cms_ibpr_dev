import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class NasabahRepository {
  static Future<dynamic> getNasabah(
    String token,
    String url,
    String username,
    String bprId,
    String kdKantor,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "userlogin": username,
      "kd_kantor":kdKantor
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

  static Future<dynamic> approveFotoCollme(
    String token,
    String url,
    String id,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "id": id,
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
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "userlogin": username,
      "trx_code": trxCode,
      "trx_type": trxType,
      "tgl_trans": tglTrans,
      "tgl_transmis": tglTransmis,
      "rrn": rrn,
      "no_rek": noRek,
      "gl_jns": glJns,
    };
    print(jsonEncode(json));
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

  static Future<dynamic> insertGallery(
    String token,
    String url,
    Uint8List ktp,
    String ktpName,
    Uint8List selfiktp,
    String selfiktpName,
  ) async {
    FormData formData = FormData.fromMap({
      "token": token,
      "selfiktp": MultipartFile.fromBytes(selfiktp, filename: selfiktpName),
      "ktp": MultipartFile.fromBytes(ktp, filename: ktpName),
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
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "acct_type": acctType,
      "gender": gender,
      "no_hp": noHp,
      "tgl_lahir": tglLahir,
      "nama_rek": namaRek,
      "no_rek": noRek,
      "nama": nama,
      "no_ktp": noKtp,
      "fhoto_1": fhoto1,
      "fhoto_2": fhoto2,
      "fhoto_3": "",
      "userlogin": username,
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
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "acct_type": acctType,
      "gender": gender,
      "no_hp": noHp,
      "tgl_lahir": tglLahir,
      "nama_rek": namaRek,
      "no_rek": noRek,
      "nama": nama,
      "no_ktp": noKtp,
      "fhoto_1": fhoto1,
      "fhoto_2": fhoto2,
      "fhoto_3": "",
      "userlogin": username,
      "no_hp_lama": noHpLama,
      "no_rek_lama": noRekLama,
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

  static Future<dynamic> generatedMpin(
    String token,
    String url,
    String kdKantor,
    String bprId,
    String userslogin,
    // List<>
    String data,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "term": "",
      "bpr_id": bprId,
      "kd_kantor": kdKantor,
      "userlogin": userslogin,
      "data": jsonDecode(data),
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
}
