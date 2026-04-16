import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class NsaabahModel {

  const NsaabahModel({
    required this.noHp,
    required this.noKtp,
    required this.nama,
    required this.namaRek,
    required this.noRek,
    required this.acctType,
    required this.status,
    required this.kdKantor,
    required this.bprId,
    required this.tglLahir,
    required this.gender,
    required this.fhoto1,
    required this.fhoto2,
    required this.fhoto3,
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
  final dynamic tglLahir;
  final dynamic gender;
  final dynamic fhoto1;
  final dynamic fhoto2;
  final dynamic fhoto3;

  factory NsaabahModel.fromJson(Map<String,dynamic> json) => NsaabahModel(
    noHp: json['no_hp'].toString(),
    noKtp: json['no_ktp'].toString(),
    nama: json['nama'].toString(),
    namaRek: json['nama_rek'].toString(),
    noRek: json['no_rek'].toString(),
    acctType: json['acct_type'].toString(),
    status: json['status'].toString(),
    kdKantor: json['kd_kantor'].toString(),
    bprId: json['bpr_id'].toString(),
    tglLahir: json['tgl_lahir'] as dynamic,
    gender: json['gender'] as dynamic,
    fhoto1: json['fhoto_1'] as dynamic,
    fhoto2: json['fhoto_2'] as dynamic,
    fhoto3: json['fhoto_3'] as dynamic
  );
  
  Map<String, dynamic> toJson() => {
    'no_hp': noHp,
    'no_ktp': noKtp,
    'nama': nama,
    'nama_rek': namaRek,
    'no_rek': noRek,
    'acct_type': acctType,
    'status': status,
    'kd_kantor': kdKantor,
    'bpr_id': bprId,
    'tgl_lahir': tglLahir,
    'gender': gender,
    'fhoto_1': fhoto1,
    'fhoto_2': fhoto2,
    'fhoto_3': fhoto3
  };

  NsaabahModel clone() => NsaabahModel(
    noHp: noHp,
    noKtp: noKtp,
    nama: nama,
    namaRek: namaRek,
    noRek: noRek,
    acctType: acctType,
    status: status,
    kdKantor: kdKantor,
    bprId: bprId,
    tglLahir: tglLahir,
    gender: gender,
    fhoto1: fhoto1,
    fhoto2: fhoto2,
    fhoto3: fhoto3
  );


  NsaabahModel copyWith({
    String? noHp,
    String? noKtp,
    String? nama,
    String? namaRek,
    String? noRek,
    String? acctType,
    String? status,
    String? kdKantor,
    String? bprId,
    dynamic? tglLahir,
    dynamic? gender,
    dynamic? fhoto1,
    dynamic? fhoto2,
    dynamic? fhoto3
  }) => NsaabahModel(
    noHp: noHp ?? this.noHp,
    noKtp: noKtp ?? this.noKtp,
    nama: nama ?? this.nama,
    namaRek: namaRek ?? this.namaRek,
    noRek: noRek ?? this.noRek,
    acctType: acctType ?? this.acctType,
    status: status ?? this.status,
    kdKantor: kdKantor ?? this.kdKantor,
    bprId: bprId ?? this.bprId,
    tglLahir: tglLahir ?? this.tglLahir,
    gender: gender ?? this.gender,
    fhoto1: fhoto1 ?? this.fhoto1,
    fhoto2: fhoto2 ?? this.fhoto2,
    fhoto3: fhoto3 ?? this.fhoto3,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is NsaabahModel && noHp == other.noHp && noKtp == other.noKtp && nama == other.nama && namaRek == other.namaRek && noRek == other.noRek && acctType == other.acctType && status == other.status && kdKantor == other.kdKantor && bprId == other.bprId && tglLahir == other.tglLahir && gender == other.gender && fhoto1 == other.fhoto1 && fhoto2 == other.fhoto2 && fhoto3 == other.fhoto3;

  @override
  int get hashCode => noHp.hashCode ^ noKtp.hashCode ^ nama.hashCode ^ namaRek.hashCode ^ noRek.hashCode ^ acctType.hashCode ^ status.hashCode ^ kdKantor.hashCode ^ bprId.hashCode ^ tglLahir.hashCode ^ gender.hashCode ^ fhoto1.hashCode ^ fhoto2.hashCode ^ fhoto3.hashCode;
}
