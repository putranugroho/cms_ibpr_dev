import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UsersAccessModel {

  const UsersAccessModel({
    required this.userid,
    required this.pass,
    required this.namauser,
    required this.kdkantor,
    required this.tglexp,
    required this.lvluser,
    required this.stsaktif,
    required this.stsrec,
    required this.stslogin,
    required this.terminalId,
    required this.kdbank,
    required this.namaKantor,
  });

  final String userid;
  final String pass;
  final String namauser;
  final String kdkantor;
  final String tglexp;
  final String lvluser;
  final String stsaktif;
  final String stsrec;
  final int stslogin;
  final String terminalId;
  final String kdbank;
  final dynamic namaKantor;

  factory UsersAccessModel.fromJson(Map<String,dynamic> json) => UsersAccessModel(
    userid: json['userid'].toString(),
    pass: json['pass'].toString(),
    namauser: json['namauser'].toString(),
    kdkantor: json['kdkantor'].toString(),
    tglexp: json['tglexp'].toString(),
    lvluser: json['lvluser'].toString(),
    stsaktif: json['stsaktif'].toString(),
    stsrec: json['stsrec'].toString(),
    stslogin: json['stslogin'] as int,
    terminalId: json['terminal_id'].toString(),
    kdbank: json['kdbank'].toString(),
    namaKantor: json['nama_kantor'] as dynamic
  );
  
  Map<String, dynamic> toJson() => {
    'userid': userid,
    'pass': pass,
    'namauser': namauser,
    'kdkantor': kdkantor,
    'tglexp': tglexp,
    'lvluser': lvluser,
    'stsaktif': stsaktif,
    'stsrec': stsrec,
    'stslogin': stslogin,
    'terminal_id': terminalId,
    'kdbank': kdbank,
    'nama_kantor': namaKantor
  };

  UsersAccessModel clone() => UsersAccessModel(
    userid: userid,
    pass: pass,
    namauser: namauser,
    kdkantor: kdkantor,
    tglexp: tglexp,
    lvluser: lvluser,
    stsaktif: stsaktif,
    stsrec: stsrec,
    stslogin: stslogin,
    terminalId: terminalId,
    kdbank: kdbank,
    namaKantor: namaKantor
  );


  UsersAccessModel copyWith({
    String? userid,
    String? pass,
    String? namauser,
    String? kdkantor,
    String? tglexp,
    String? lvluser,
    String? stsaktif,
    String? stsrec,
    int? stslogin,
    String? terminalId,
    String? kdbank,
    dynamic? namaKantor
  }) => UsersAccessModel(
    userid: userid ?? this.userid,
    pass: pass ?? this.pass,
    namauser: namauser ?? this.namauser,
    kdkantor: kdkantor ?? this.kdkantor,
    tglexp: tglexp ?? this.tglexp,
    lvluser: lvluser ?? this.lvluser,
    stsaktif: stsaktif ?? this.stsaktif,
    stsrec: stsrec ?? this.stsrec,
    stslogin: stslogin ?? this.stslogin,
    terminalId: terminalId ?? this.terminalId,
    kdbank: kdbank ?? this.kdbank,
    namaKantor: namaKantor ?? this.namaKantor,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UsersAccessModel && userid == other.userid && pass == other.pass && namauser == other.namauser && kdkantor == other.kdkantor && tglexp == other.tglexp && lvluser == other.lvluser && stsaktif == other.stsaktif && stsrec == other.stsrec && stslogin == other.stslogin && terminalId == other.terminalId && kdbank == other.kdbank && namaKantor == other.namaKantor;

  @override
  int get hashCode => userid.hashCode ^ pass.hashCode ^ namauser.hashCode ^ kdkantor.hashCode ^ tglexp.hashCode ^ lvluser.hashCode ^ stsaktif.hashCode ^ stsrec.hashCode ^ stslogin.hashCode ^ terminalId.hashCode ^ kdbank.hashCode ^ namaKantor.hashCode;
}
