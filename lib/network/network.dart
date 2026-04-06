import 'package:flutter/material.dart';
import 'dart:core';

const token = "715f8ab555438f985b579844ea227767";
const xusername = "core@2023";
const xpassword = "corevalue@20231234";
const url = "https://ibprservices.medtrans.id";
const url2 = "https://infoservices.medtrans.id";
const url_go = "http://103.129.149.131:8090";
const upload = "https://infoservices.medtrans.id/upload";
const photo = "https://infoservices.medtrans.id/photo";

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

class NetworkURL {
  static String login() {
    return "$url/webServices/login_cms_dev.php";
  }

  static String getUsersAccess() {
    return "$url_go/user_search";
  }

  static String getListKantorAccess() {
    return "$url_go/kantor";
  }

  static String getListNasbah() {
    return "$url_go/account_search";
  }

  static String getListMobileInfo() {
    return "$url2/webServices/users_info_inquiry.php";
  }

  static String generatedMpin() {
    return "$url_go/generate_mpin";
  }

  static String insertKantorCMS() {
    return "$url/webServices/insert_kantor_cms.php";
  }

  static String updateKantorCMS() {
    return "$url/webServices/update_kantor_cms.php";
  }

  static String deleteKantorCMS() {
    return "$url/webServices/delete_kantor_cms.php";
  }

  static String insertUsersId() {
    return "$url_go/user_management";
  }

  static String updateUsersId() {
    return "$url_go/user_management";
  }

  static String getListFasilitas() {
    return "$url_go/master_menu";
  }

  static String getListFasilitasByUsers() {
    return "$url_go/fasilitas_akses";
  }

  static String getListAcctType() {
    return "$url/webServices/get_list_acct_type.php";
  }

  static String insertAcctTYpe() {
    return "$url/webServices/insert_acct_type.php";
  }

  static String updateAcctTYpe() {
    return "$url/webServices/update_acct_type.php";
  }

  static String deleteAcctTYpe() {
    return "$url/webServices/delete_acct_type.php";
  }

  static String getLimitHarian() {
    return "$url/webServices/get_limit_harian.php";
  }

  static String insertLimitHarian() {
    return "$url/webServices/insert_limit_harian.php";
  }

  static String getLimitTrx() {
    return "$url/webServices/get_limit_trx.php";
  }

  static String insertLimitTrx() {
    return "$url/webServices/insert_limit_trx.php";
  }

  static String insertGallery() {
    return "$url_go/photo/upload";
  }

  static String photoView({
    required String type,
    required String? fileOrPath,
  }) {
    if (fileOrPath == null || fileOrPath.trim().isEmpty) {
      return "";
    }

    final normalized = fileOrPath.replaceAll("\\", "/");
    final fileName = normalized.split("/").last;

    return Uri.parse("$url_go/photo/view").replace(queryParameters: {
      "type": type,
      "file": fileName,
    }).toString();
  }

  static String insertAKunCMS() {
    return "$url_go/account";
  }

  static String inqueryRekCMS() {
    return "$url_go/inquiry_account";
  }

  static String updateAkunCms() {
    return "$url_go/account";
  }

  static String deleteAkunCms() {
    return "$url_go/account";
  }

  static String generatedMPIN() {
    return "$url/webServices/generated_mpin_cms.php";
  }

  static String regeneratedMPIN() {
    return "$url/webServices/regenerated_mpin_cms.php";
  }

  static String inqueryHp() {
    return "$url_go/account_search";
  }

  static String updateMpinCetak() {
    return "$url_go/update_print_mpin";
  }

  static String validateCard() {
    return "$url/webServices/validate_card_new.php";
  }

  static String gantiMpinCMS() {
    return "$url/webServices/ganti_mpin_cms.php";
  }

  static String blokirAkunCMS() {
    return "$url/webServices/blokir_nasabah_cms.php";
  }

  static String unblokirAkunCMS() {
    return "$url/webServices/unblokir_nasabah_cms.php";
  }

  static String mPinGeneratedValidated() {
    return "$url/webServices/m_pin_generated_dev.php";
  }

  static String inqueryMpinDev() {
    return "$url/webServices/inquery_mpin_dev.php";
  }

  static String addCardNew() {
    return "$url/webServices/add_card_new.php";
  }

  static String tutupNasabahCms() {
    return "$url/webServices/tutup_nasabah_cms.php";
  }

  static String resetMpin() {
    return "$url/webServices/reset_mpin_cms.php";
  }

  static String getFotoNasabah() {
    return "$url/webServices/get_foto_nasabah_.php";
  }

  static String logout() {
    return "$url/webServices/logout_cis_dev.php";
  }

  static String updateFotoNasabahCollme() {
    return "$url/webServices/update_foto_nasabah_collme_.php";
  }

  static String approveFotoCollme() {
    return "$url/webServices/terima_foto_nasabah_collme_.php";
  }

  static String gantipassword() {
    return "$url/webServices/ganti_users_password.php";
  }

  static String inqueryRek() {
    return "$url2/webServices/inquery_info_rek.php";
  }

  static String usersinfocreate() {
    return "$url2/webServices/users_info_create.php";
  }
}
