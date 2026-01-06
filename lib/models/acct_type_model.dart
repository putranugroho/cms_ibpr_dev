import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class AcctTypeModel {

  const AcctTypeModel({
    required this.kdAcc,
    required this.keterangan,
  });

  final String kdAcc;
  final String keterangan;

  factory AcctTypeModel.fromJson(Map<String,dynamic> json) => AcctTypeModel(
    kdAcc: json['kd_acc'].toString(),
    keterangan: json['keterangan'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'kd_acc': kdAcc,
    'keterangan': keterangan
  };

  AcctTypeModel clone() => AcctTypeModel(
    kdAcc: kdAcc,
    keterangan: keterangan
  );


  AcctTypeModel copyWith({
    String? kdAcc,
    String? keterangan
  }) => AcctTypeModel(
    kdAcc: kdAcc ?? this.kdAcc,
    keterangan: keterangan ?? this.keterangan,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is AcctTypeModel && kdAcc == other.kdAcc && keterangan == other.keterangan;

  @override
  int get hashCode => kdAcc.hashCode ^ keterangan.hashCode;
}
