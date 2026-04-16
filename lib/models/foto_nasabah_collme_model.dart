import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class FotoNasabahCollmeModel {

  const FotoNasabahCollmeModel({
    required this.id,
    required this.bprId,
    required this.namaNasabah,
    required this.noRek,
    required this.phone,
    required this.ktp,
    required this.selfiKtp,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
    required this.reasonRejected,
    required this.fotoBaru,
  });

  final int id;
  final String bprId;
  final String namaNasabah;
  final String noRek;
  final String phone;
  final String ktp;
  final String selfiKtp;
  final String status;
  final String createdDate;
  final String updatedDate;
  final String reasonRejected;
  final String fotoBaru;

  factory FotoNasabahCollmeModel.fromJson(Map<String,dynamic> json) => FotoNasabahCollmeModel(
    id: json['id'] as int,
    bprId: json['bpr_id'].toString(),
    namaNasabah: json['nama_nasabah'].toString(),
    noRek: json['no_rek'].toString(),
    phone: json['phone'].toString(),
    ktp: json['ktp'].toString(),
    selfiKtp: json['selfi_ktp'].toString(),
    status: json['status'].toString(),
    createdDate: json['createdDate'].toString(),
    updatedDate: json['updatedDate'].toString(),
    reasonRejected: json['reason_rejected'].toString(),
    fotoBaru: json['foto_baru'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'bpr_id': bprId,
    'nama_nasabah': namaNasabah,
    'no_rek': noRek,
    'phone': phone,
    'ktp': ktp,
    'selfi_ktp': selfiKtp,
    'status': status,
    'createdDate': createdDate,
    'updatedDate': updatedDate,
    'reason_rejected': reasonRejected,
    'foto_baru': fotoBaru
  };

  FotoNasabahCollmeModel clone() => FotoNasabahCollmeModel(
    id: id,
    bprId: bprId,
    namaNasabah: namaNasabah,
    noRek: noRek,
    phone: phone,
    ktp: ktp,
    selfiKtp: selfiKtp,
    status: status,
    createdDate: createdDate,
    updatedDate: updatedDate,
    reasonRejected: reasonRejected,
    fotoBaru: fotoBaru
  );


  FotoNasabahCollmeModel copyWith({
    int? id,
    String? bprId,
    String? namaNasabah,
    String? noRek,
    String? phone,
    String? ktp,
    String? selfiKtp,
    String? status,
    String? createdDate,
    String? updatedDate,
    String? reasonRejected,
    String? fotoBaru
  }) => FotoNasabahCollmeModel(
    id: id ?? this.id,
    bprId: bprId ?? this.bprId,
    namaNasabah: namaNasabah ?? this.namaNasabah,
    noRek: noRek ?? this.noRek,
    phone: phone ?? this.phone,
    ktp: ktp ?? this.ktp,
    selfiKtp: selfiKtp ?? this.selfiKtp,
    status: status ?? this.status,
    createdDate: createdDate ?? this.createdDate,
    updatedDate: updatedDate ?? this.updatedDate,
    reasonRejected: reasonRejected ?? this.reasonRejected,
    fotoBaru: fotoBaru ?? this.fotoBaru,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is FotoNasabahCollmeModel && id == other.id && bprId == other.bprId && namaNasabah == other.namaNasabah && noRek == other.noRek && phone == other.phone && ktp == other.ktp && selfiKtp == other.selfiKtp && status == other.status && createdDate == other.createdDate && updatedDate == other.updatedDate && reasonRejected == other.reasonRejected && fotoBaru == other.fotoBaru;

  @override
  int get hashCode => id.hashCode ^ bprId.hashCode ^ namaNasabah.hashCode ^ noRek.hashCode ^ phone.hashCode ^ ktp.hashCode ^ selfiKtp.hashCode ^ status.hashCode ^ createdDate.hashCode ^ updatedDate.hashCode ^ reasonRejected.hashCode ^ fotoBaru.hashCode;
}
