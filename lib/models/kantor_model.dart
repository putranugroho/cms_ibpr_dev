import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class KantorModel {

  const KantorModel({
    required this.kdBank,
    required this.kdKantor,
    required this.namaKantor,
  });

  final dynamic kdBank;
  final dynamic kdKantor;
  final dynamic namaKantor;

  factory KantorModel.fromJson(Map<String,dynamic> json) => KantorModel(
    kdBank: json['kd_bank'] as dynamic,
    kdKantor: json['kd_kantor'] as dynamic,
    namaKantor: json['nama_kantor'] as dynamic
  );
  
  Map<String, dynamic> toJson() => {
    'kd_bank': kdBank,
    'kd_kantor': kdKantor,
    'nama_kantor': namaKantor
  };

  KantorModel clone() => KantorModel(
    kdBank: kdBank,
    kdKantor: kdKantor,
    namaKantor: namaKantor
  );


  KantorModel copyWith({
    dynamic? kdBank,
    dynamic? kdKantor,
    dynamic? namaKantor
  }) => KantorModel(
    kdBank: kdBank ?? this.kdBank,
    kdKantor: kdKantor ?? this.kdKantor,
    namaKantor: namaKantor ?? this.namaKantor,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is KantorModel && kdBank == other.kdBank && kdKantor == other.kdKantor && namaKantor == other.namaKantor;

  @override
  int get hashCode => kdBank.hashCode ^ kdKantor.hashCode ^ namaKantor.hashCode;
}
