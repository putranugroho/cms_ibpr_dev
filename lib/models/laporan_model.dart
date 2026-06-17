String laporanString(dynamic value) {
  if (value == null) return "";
  final text = value.toString().trim();
  if (text.toLowerCase() == "null") return "";
  return text;
}

String laporanPick(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key)) {
      final value = laporanString(json[key]);
      if (value.isNotEmpty) return value;
    }
  }
  return "";
}

String laporanNormalizeStatus(dynamic value) {
  final raw = laporanString(value).toUpperCase();
  if (raw.isEmpty) return "-";

  if (["1", "Y", "YA", "A", "AKTIF", "ACTIVE", "TRUE"].contains(raw)) {
    return "AKTIF";
  }
  if (["0", "N", "TIDAK", "NONAKTIF", "NON AKTIF", "INACTIVE", "FALSE"].contains(raw)) {
    return "NONAKTIF";
  }
  if (["B", "BLOKIR", "BLOCK", "BLOCKED"].contains(raw)) {
    return "BLOKIR";
  }
  if (["T", "TUTUP", "CLOSE", "CLOSED"].contains(raw)) {
    return "TUTUP";
  }
  if (["H", "D", "DEL", "DELETE", "DELETED", "HAPUS"].contains(raw)) {
    return "HAPUS";
  }

  return raw;
}

int laporanStatusRank(String status) {
  final value = status.trim().toUpperCase();
  if (value == "AKTIF") return 1;
  if (value == "NONAKTIF") return 2;
  if (value == "BLOKIR") return 3;
  if (value == "TUTUP") return 4;
  if (value == "HAPUS") return 5;
  return 9;
}

class LaporanUserAccessItem {
  const LaporanUserAccessItem({
    required this.userid,
    required this.namauser,
    required this.kdkantor,
    required this.namaKantor,
    required this.tglexp,
    required this.lvluser,
    required this.stsaktif,
    required this.stsrec,
    required this.stslogin,
    required this.bprId,
  });

  final String userid;
  final String namauser;
  final String kdkantor;
  final String namaKantor;
  final String tglexp;
  final String lvluser;
  final String stsaktif;
  final String stsrec;
  final String stslogin;
  final String bprId;

  factory LaporanUserAccessItem.fromJson(Map<String, dynamic> json) {
    return LaporanUserAccessItem(
      userid: laporanPick(json, ["userid", "users_id", "user_id"]),
      namauser: laporanPick(json, ["namauser", "nama_user", "nama_users", "nama"]),
      kdkantor: laporanPick(json, ["kdkantor", "kd_kantor", "kode_kantor"]),
      namaKantor: laporanPick(json, ["nama_kantor", "namakantor"]),
      tglexp: laporanPick(json, ["tglexp", "tgl_exp", "tgl_expired", "expired_at"]),
      lvluser: laporanPick(json, ["lvluser", "level_user", "lvuser"]),
      stsaktif: laporanPick(json, ["stsaktif", "status_aktif", "active"]),
      stsrec: laporanPick(json, ["stsrec", "status_rec", "record_status"]),
      stslogin: laporanPick(json, ["stslogin", "status_login"]),
      bprId: laporanPick(json, ["bpr_id", "bprid"]),
    );
  }

  String get statusLabel {
    final recStatus = laporanNormalizeStatus(stsrec);
    if (recStatus == "HAPUS") return "HAPUS";
    return laporanNormalizeStatus(stsaktif);
  }

  bool get isHapus => statusLabel == "HAPUS";
}

class LaporanAkunIbprItem {
  const LaporanAkunIbprItem({
    required this.noHp,
    required this.noKtp,
    required this.nama,
    required this.namaRek,
    required this.noRek,
    required this.acctType,
    required this.status,
    required this.kdKantor,
    required this.bprId,
    required this.tglData,
  });

  final String noHp;
  final String noKtp;
  final String nama;
  final String namaRek;
  final String noRek;
  final String acctType;
  final String status;
  final String kdKantor;
  final String bprId;
  final String tglData;

  factory LaporanAkunIbprItem.fromJson(Map<String, dynamic> json) {
    return LaporanAkunIbprItem(
      noHp: laporanPick(json, ["no_hp", "nohp", "phone", "nomor_hp"]),
      noKtp: laporanPick(json, ["no_ktp", "nik", "no_identitas"]),
      nama: laporanPick(json, ["nama", "nama_lengkap", "nama_user"]),
      namaRek: laporanPick(json, ["nama_rek", "nama_rekening", "namarek"]),
      noRek: laporanPick(json, ["no_rek", "norek", "no_rekening", "nomor_akun", "no_akun"]),
      acctType: laporanPick(json, ["acct_type", "account_type", "jenis_akun"]),
      status: laporanPick(json, ["status", "stsaktif", "status_aktif"]),
      kdKantor: laporanPick(json, ["kd_kantor", "kdkantor", "kode_kantor"]),
      bprId: laporanPick(json, ["bpr_id", "bprid"]),
      tglData: laporanPick(json, [
        "tgl_data",
        "tgl_register",
        "tgl_daftar",
        "tgl_create",
        "tgl_created",
        "created_date",
        "created_at",
        "updated_at",
      ]),
    );
  }

  String get statusLabel => laporanNormalizeStatus(status);

  String get key => "${noRek.trim()}|${noHp.trim()}";

  String get label {
    final primary = noRek.trim().isNotEmpty ? noRek.trim() : noHp.trim();
    final name = nama.trim().isNotEmpty ? nama.trim() : namaRek.trim();
    if (primary.isEmpty && name.isEmpty) return "-";
    if (name.isEmpty) return primary;
    if (primary.isEmpty) return name;
    return "$primary - $name";
  }
}

class LaporanTrxItem {
  const LaporanTrxItem({
    required this.id,
    required this.trxCategory,
    required this.trxDirection,
    required this.bprId,
    required this.namaBpr,
    required this.rrn,
    required this.refId,
    required this.noRek,
    required this.noHp,
    required this.trxCode,
    required this.productName,
    required this.amount,
    required this.adminFee,
    required this.feeBpr,
    required this.tglTrans,
    required this.tglTransDate,
    required this.finalCode,
    required this.finalStatus,
    required this.finalMessage,
    required this.failedAtLayer,
    required this.failedAtStep,
    required this.durationMs,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String trxCategory;
  final String trxDirection;
  final String bprId;
  final String namaBpr;
  final String rrn;
  final String refId;
  final String noRek;
  final String noHp;
  final String trxCode;
  final String productName;
  final double amount;
  final double adminFee;
  final double feeBpr;
  final String tglTrans;
  final String tglTransDate;
  final String finalCode;
  final String finalStatus;
  final String finalMessage;
  final String failedAtLayer;
  final String failedAtStep;
  final int durationMs;
  final String createdAt;
  final String updatedAt;

  factory LaporanTrxItem.fromJson(Map<String, dynamic> json) {
    return LaporanTrxItem(
      id: laporanPick(json, ["id"]),
      trxCategory: laporanPick(json, ["trx_category"]),
      trxDirection: laporanPick(json, ["trx_direction"]),
      bprId: laporanPick(json, ["bpr_id"]),
      namaBpr: laporanPick(json, ["nama_bpr"]),
      rrn: laporanPick(json, ["rrn"]),
      refId: laporanPick(json, ["ref_id"]),
      noRek: laporanPick(json, ["no_rek"]),
      noHp: laporanPick(json, ["no_hp"]),
      trxCode: laporanPick(json, ["trx_code"]),
      productName: laporanPick(json, ["product_name"]),
      amount: _toDouble(json["amount"]),
      adminFee: _toDouble(json["admin_fee"]),
      feeBpr: _toDouble(json["fee_bpr"]),
      tglTrans: laporanPick(json, ["tgl_trans"]),
      tglTransDate: laporanPick(json, ["tgl_trans_date"]),
      finalCode: laporanPick(json, ["final_code"]),
      finalStatus: laporanPick(json, ["final_status"]),
      finalMessage: laporanPick(json, ["final_message"]),
      failedAtLayer: laporanPick(json, ["failed_at_layer"]),
      failedAtStep: laporanPick(json, ["failed_at_step"]),
      durationMs: _toInt(json["duration_ms"]),
      createdAt: laporanPick(json, ["created_at"]),
      updatedAt: laporanPick(json, ["updated_at"]),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
