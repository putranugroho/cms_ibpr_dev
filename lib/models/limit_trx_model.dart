import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class LimitTrxModel {

  const LimitTrxModel({
    required this.acctType,
    required this.description,
    required this.trkTunaiTrx,
    required this.setorTrx,
    required this.trfTrx,
    required this.qrTrx,
    required this.ppobTrx,
  });

  final String acctType;
  final String description;
  final String trkTunaiTrx;
  final String setorTrx;
  final String trfTrx;
  final String qrTrx;
  final String ppobTrx;

  factory LimitTrxModel.fromJson(Map<String,dynamic> json) => LimitTrxModel(
    acctType: json['acct_type'].toString(),
    description: json['description'].toString(),
    trkTunaiTrx: json['trk_tunai_trx'].toString(),
    setorTrx: json['setor_trx'].toString(),
    trfTrx: json['trf_trx'].toString(),
    qrTrx: json['qr_trx'].toString(),
    ppobTrx: json['ppob_trx'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'acct_type': acctType,
    'description': description,
    'trk_tunai_trx': trkTunaiTrx,
    'setor_trx': setorTrx,
    'trf_trx': trfTrx,
    'qr_trx': qrTrx,
    'ppob_trx': ppobTrx
  };

  LimitTrxModel clone() => LimitTrxModel(
    acctType: acctType,
    description: description,
    trkTunaiTrx: trkTunaiTrx,
    setorTrx: setorTrx,
    trfTrx: trfTrx,
    qrTrx: qrTrx,
    ppobTrx: ppobTrx
  );


  LimitTrxModel copyWith({
    String? acctType,
    String? description,
    String? trkTunaiTrx,
    String? setorTrx,
    String? trfTrx,
    String? qrTrx,
    String? ppobTrx
  }) => LimitTrxModel(
    acctType: acctType ?? this.acctType,
    description: description ?? this.description,
    trkTunaiTrx: trkTunaiTrx ?? this.trkTunaiTrx,
    setorTrx: setorTrx ?? this.setorTrx,
    trfTrx: trfTrx ?? this.trfTrx,
    qrTrx: qrTrx ?? this.qrTrx,
    ppobTrx: ppobTrx ?? this.ppobTrx,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is LimitTrxModel && acctType == other.acctType && description == other.description && trkTunaiTrx == other.trkTunaiTrx && setorTrx == other.setorTrx && trfTrx == other.trfTrx && qrTrx == other.qrTrx && ppobTrx == other.ppobTrx;

  @override
  int get hashCode => acctType.hashCode ^ description.hashCode ^ trkTunaiTrx.hashCode ^ setorTrx.hashCode ^ trfTrx.hashCode ^ qrTrx.hashCode ^ ppobTrx.hashCode;
}
