import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UsersModel {

  const UsersModel({
    required this.bprId,
    required this.usersId,
    required this.namaUsers,
    required this.kodeKantor,
    required this.namaKantor,
  });

  final String bprId;
  final String usersId;
  final String namaUsers;
  final String kodeKantor;
  final String namaKantor;

  factory UsersModel.fromJson(Map<String,dynamic> json) => UsersModel(
    bprId: json['bpr_id'].toString(),
    usersId: json['users_id'].toString(),
    namaUsers: json['nama_users'].toString(),
    kodeKantor: json['kode_kantor'].toString(),
    namaKantor: json['nama_kantor'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'bpr_id': bprId,
    'users_id': usersId,
    'nama_users': namaUsers,
    'kode_kantor': kodeKantor,
    'nama_kantor': namaKantor
  };

  UsersModel clone() => UsersModel(
    bprId: bprId,
    usersId: usersId,
    namaUsers: namaUsers,
    kodeKantor: kodeKantor,
    namaKantor: namaKantor
  );


  UsersModel copyWith({
    String? bprId,
    String? usersId,
    String? namaUsers,
    String? kodeKantor,
    String? namaKantor
  }) => UsersModel(
    bprId: bprId ?? this.bprId,
    usersId: usersId ?? this.usersId,
    namaUsers: namaUsers ?? this.namaUsers,
    kodeKantor: kodeKantor ?? this.kodeKantor,
    namaKantor: namaKantor ?? this.namaKantor,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UsersModel && bprId == other.bprId && usersId == other.usersId && namaUsers == other.namaUsers && kodeKantor == other.kodeKantor && namaKantor == other.namaKantor;

  @override
  int get hashCode => bprId.hashCode ^ usersId.hashCode ^ namaUsers.hashCode ^ kodeKantor.hashCode ^ namaKantor.hashCode;
}
