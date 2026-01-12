import 'package:flutter/material.dart';

const token = "715f8ab555438f985b579844ea227767";
const xusername = "core@2023";
const xpassword = "corevalue@20231234";
const url = "https://infoservices.medtrans.id";
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
    return "$url/webServices/get_list_users_access_dev.php";
  }

  static String getListKantorAccess() {
    return "$url/webServices/get_list_kantor_access_dev.php";
  }

  static String getListNasbah() {
    return "$url/webServices/get_list_nasabah_dev.php";
  }

  static String getListMobileInfo() {
    return "$url/webServices/users_info_inquiry.php";
  }

  static String generatedMpin() {
    return "$url/webServices/generated_mpin_cms_dev.php";
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
    return "$url/webServices/insert_usersid_cms.php";
  }

  static String updateUsersId() {
    return "$url/webServices/update_usersid_cms.php";
  }

  static String getListFasilitas() {
    return "$url/webServices/get_list_fasilitas_.php";
  }

  static String getListFasilitasByUsers() {
    return "$url/webServices/get_list_fasilitas_byusers_.php";
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
    return "$url/webServices/insert_gallery_akun.php";
  }

  static String insertAKunCMS() {
    return "$url/webServices/insert_akun_cms.php";
  }

  static String inqueryRekCMS() {
    return "$url/webServices/inquery_rek_cms.php";
  }

  static String updateAkunCms() {
    return "$url/webServices/update_akun_cms.php";
  }

  static String deleteAkunCms() {
    return "$url/webServices/delete_akun_cms.php";
  }

  static String generatedMPIN() {
    return "$url/webServices/generated_mpin_cms.php";
  }

  static String regeneratedMPIN() {
    return "$url/webServices/regenerated_mpin_cms.php";
  }

  static String inqueryHp() {
    return "$url/webServices/inquery_hp_cms.php";
  }

  static String updateMpinCetak() {
    return "$url/webServices/update_mpin_cetak.php";
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
    return "$url/webServices/inquery_info_rek.php";
  }

  static String usersinfocreate() {
    return "$url/webServices/users_info_create.php";
  }
}
