import 'package:flutter/foundation.dart';

@immutable
class KantorModel {
  const KantorModel({
    required this.bpr_id,
    required this.kdKantor,
    required this.namaKantor,
    this.id = '',
    this.branchType = '',
    this.isDefault = false,
    this.employeeCount = 0,
    this.address = '',
    this.email = '',
    this.phone = '',
    this.latitude = 0,
    this.longitude = 0,
    this.radiusMeters = 0,
  });

  final dynamic bpr_id;
  final dynamic kdKantor;
  final dynamic namaKantor;
  final String id;
  final String branchType;
  final bool isDefault;
  final int employeeCount;
  final String address;
  final String email;
  final String phone;
  final double latitude;
  final double longitude;
  final int radiusMeters;

  static String _text(dynamic value) {
    if (value == null) return '';
    final text = value.toString().trim();
    return text.toLowerCase() == 'null' ? '' : text;
  }

  static bool _boolean(dynamic value) {
    if (value is bool) return value;
    final text = _text(value).toLowerCase();
    return text == 'true' || text == '1' || text == 'y';
  }

  static int _integer(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_text(value)) ?? 0;
  }

  static double _decimal(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(_text(value)) ?? 0;
  }

  factory KantorModel.fromJson(Map<String, dynamic> json) => KantorModel(
        bpr_id: _text(json['bpr_id'] ?? json['bpr_code']),
        kdKantor: _text(json['kd_kantor'] ?? json['branch_code']),
        namaKantor: _text(json['nama_kantor'] ?? json['name']),
        id: _text(json['id']),
        branchType: _text(json['branch_type']),
        isDefault: _boolean(json['is_default']),
        employeeCount: _integer(json['employee_count']),
        address: _text(json['address']),
        email: _text(json['email']),
        phone: _text(json['phone']),
        latitude: _decimal(json['latitude']),
        longitude: _decimal(json['longitude']),
        radiusMeters: _integer(json['radius_meters']),
      );

  Map<String, dynamic> toJson() => {
        'bpr_id': bpr_id,
        'kd_kantor': kdKantor,
        'nama_kantor': namaKantor,
        'id': id,
        'branch_type': branchType,
        'is_default': isDefault,
        'employee_count': employeeCount,
        'address': address,
        'email': email,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude,
        'radius_meters': radiusMeters,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KantorModel &&
          bpr_id == other.bpr_id &&
          kdKantor == other.kdKantor &&
          id == other.id;

  @override
  int get hashCode => Object.hash(bpr_id, kdKantor, id);
}
