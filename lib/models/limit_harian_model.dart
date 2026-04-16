import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class LimitHarianModel {

  const LimitHarianModel({
    required this.acctType,
    required this.description,
    required this.trkTunaiHarian,
    required this.setorHarian,
    required this.trfHarian,
    required this.qrHarian,
    required this.ppobHarian,
  });

  final String acctType;
  final String description;
  final String trkTunaiHarian;
  final String setorHarian;
  final String trfHarian;
  final String qrHarian;
  final String ppobHarian;

  factory LimitHarianModel.fromJson(Map<String,dynamic> json) => LimitHarianModel(
    acctType: json['acct_type'].toString(),
    description: json['description'].toString(),
    trkTunaiHarian: json['trk_tunai_harian'].toString(),
    setorHarian: json['setor_harian'].toString(),
    trfHarian: json['trf_harian'].toString(),
    qrHarian: json['qr_harian'].toString(),
    ppobHarian: json['ppob_harian'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'acct_type': acctType,
    'description': description,
    'trk_tunai_harian': trkTunaiHarian,
    'setor_harian': setorHarian,
    'trf_harian': trfHarian,
    'qr_harian': qrHarian,
    'ppob_harian': ppobHarian
  };

  LimitHarianModel clone() => LimitHarianModel(
    acctType: acctType,
    description: description,
    trkTunaiHarian: trkTunaiHarian,
    setorHarian: setorHarian,
    trfHarian: trfHarian,
    qrHarian: qrHarian,
    ppobHarian: ppobHarian
  );


  LimitHarianModel copyWith({
    String? acctType,
    String? description,
    String? trkTunaiHarian,
    String? setorHarian,
    String? trfHarian,
    String? qrHarian,
    String? ppobHarian
  }) => LimitHarianModel(
    acctType: acctType ?? this.acctType,
    description: description ?? this.description,
    trkTunaiHarian: trkTunaiHarian ?? this.trkTunaiHarian,
    setorHarian: setorHarian ?? this.setorHarian,
    trfHarian: trfHarian ?? this.trfHarian,
    qrHarian: qrHarian ?? this.qrHarian,
    ppobHarian: ppobHarian ?? this.ppobHarian,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is LimitHarianModel && acctType == other.acctType && description == other.description && trkTunaiHarian == other.trkTunaiHarian && setorHarian == other.setorHarian && trfHarian == other.trfHarian && qrHarian == other.qrHarian && ppobHarian == other.ppobHarian;

  @override
  int get hashCode => acctType.hashCode ^ description.hashCode ^ trkTunaiHarian.hashCode ^ setorHarian.hashCode ^ trfHarian.hashCode ^ qrHarian.hashCode ^ ppobHarian.hashCode;
}
