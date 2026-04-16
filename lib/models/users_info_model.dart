import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UsersInfoModel {

  const UsersInfoModel({
    required this.id,
    required this.noCif,
    required this.username,
    required this.bprId,
    required this.nama,
    required this.phone,
    required this.tglLahir,
    required this.noIdentitas,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isDeleted,
  });

  final int id;
  final String noCif;
  final String username;
  final String bprId;
  final String nama;
  final String phone;
  final String tglLahir;
  final String noIdentitas;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final String isDeleted;

  factory UsersInfoModel.fromJson(Map<String,dynamic> json) => UsersInfoModel(
    id: json['id'] as int,
    noCif: json['no_cif'].toString(),
    username: json['username'].toString(),
    bprId: json['bpr_id'].toString(),
    nama: json['nama'].toString(),
    phone: json['phone'].toString(),
    tglLahir: json['tgl_lahir'].toString(),
    noIdentitas: json['no_identitas'].toString(),
    createdAt: json['created_at'].toString(),
    updatedAt: json['updated_at'].toString(),
    deletedAt: json['deleted_at'].toString(),
    isDeleted: json['is_deleted'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'no_cif': noCif,
    'username': username,
    'bpr_id': bprId,
    'nama': nama,
    'phone': phone,
    'tgl_lahir': tglLahir,
    'no_identitas': noIdentitas,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_deleted': isDeleted
  };

  UsersInfoModel clone() => UsersInfoModel(
    id: id,
    noCif: noCif,
    username: username,
    bprId: bprId,
    nama: nama,
    phone: phone,
    tglLahir: tglLahir,
    noIdentitas: noIdentitas,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    isDeleted: isDeleted
  );


  UsersInfoModel copyWith({
    int? id,
    String? noCif,
    String? username,
    String? bprId,
    String? nama,
    String? phone,
    String? tglLahir,
    String? noIdentitas,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? isDeleted
  }) => UsersInfoModel(
    id: id ?? this.id,
    noCif: noCif ?? this.noCif,
    username: username ?? this.username,
    bprId: bprId ?? this.bprId,
    nama: nama ?? this.nama,
    phone: phone ?? this.phone,
    tglLahir: tglLahir ?? this.tglLahir,
    noIdentitas: noIdentitas ?? this.noIdentitas,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UsersInfoModel && id == other.id && noCif == other.noCif && username == other.username && bprId == other.bprId && nama == other.nama && phone == other.phone && tglLahir == other.tglLahir && noIdentitas == other.noIdentitas && createdAt == other.createdAt && updatedAt == other.updatedAt && deletedAt == other.deletedAt && isDeleted == other.isDeleted;

  @override
  int get hashCode => id.hashCode ^ noCif.hashCode ^ username.hashCode ^ bprId.hashCode ^ nama.hashCode ^ phone.hashCode ^ tglLahir.hashCode ^ noIdentitas.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ deletedAt.hashCode ^ isDeleted.hashCode;
}
