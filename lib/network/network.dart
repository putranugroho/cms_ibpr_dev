import 'package:flutter/material.dart';
import 'dart:core';

const token = "715f8ab555438f985b579844ea227767";
const xusername = "core@2023";
const xpassword = "corevalue@20231234";
const url = "https://ibprservices.medtrans.id";
const url2 = "https://infoservices.medtrans.id";
const url_go = "https://api-dev-cms.medtrans.id";
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
    return "$url_go/login";
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
    return "$url_go/kantor";
  }

  static String updateKantorCMS() {
    return "$url_go/kantor";
  }

  static String deleteKantorCMS() {
    return "$url_go/kantor";
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
    return "$url_go/acctype";
  }

  static String insertAcctTYpe() {
    return "$url_go/acctype";
  }

  static String updateAcctTYpe() {
    return "$url_go/acctype";
  }

  static String deleteAcctTYpe() {
    return "$url_go/acctype";
  }

  static String getLimitHarian() {
    return "$url_go/acctype_limit";
  }

  static String insertLimitHarian() {
    return "$url_go/acctype_limit";
  }

  static String getLimitTrx() {
    return "$url_go/acctype_limit";
  }

  static String insertLimitTrx() {
    return "$url_go/acctype_limit";
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
    return "$url_go/logout";
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

  static String regenerateMpinGo() {
    return "$url_go/regenerate_mpin";
  }

  static String resetMpinGo() {
    return "$url_go/reset_mpin";
  }

  static String inquiryUserAccount() {
    return "$url_go/inquiry_user_account";
  }

  static String resetPasswordNasabah() {
    return "$url_go/reset_login_status";
  }

  static String setupTransaksi() {
    return "$url_go/setup_transaksi";
  }
}
