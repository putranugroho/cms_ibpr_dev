import 'dart:convert';

import 'package:cms_ibpr/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/network.dart';

class UsersAccessRepository {
  static Future<dynamic> getUsersAccess(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "userid": username,
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

  static Future<dynamic> getListFasilitas(
    String token,
    String url,
    String username,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
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

  static Future<dynamic> getListFasilitasByUsers(
    String token,
    String url,
    String username,
    String userId,
    String bprId,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "userlogin": username,
      "userid": userId,
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

  static Future<dynamic> insertUsersId(
    String token,
    String url,
    String bprId,
    String usersId,
    String password,
    String username,
    String namaUsers,
    String kdbank,
    String kdkantor,
    String tglexp,
    String lvluser,
    String fasilitas,
  ) async {
    Map<String, dynamic> json = {
      "token": token,
      "bpr_id": bprId,
      "userlogin": usersId,
      "userid": username,
      "username": username,
      "password": password,
      "pass": encryptString(password),
      "namauser": namaUsers,
      "kdkantor": kdkantor,
      "kdbank": kdbank,
      "tglexp": tglexp,
      "lvluser": lvluser,
      "fasilitas": jsonDecode(fasilitas),
    };

    // print(jsonEncode(json));
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
