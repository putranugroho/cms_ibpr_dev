import 'package:flutter/foundation.dart';

@immutable
class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.employeeNo,
    required this.name,
    required this.officeId,
    required this.officeCode,
    required this.officeName,
    required this.officeType,
    this.nik = '',
    this.phone = '',
    this.employeeStatus = '',
    this.department = '',
    this.division = '',
    this.position = '',
    this.level = '',
    this.photo = '',
  });

  final String id;
  final String employeeNo;
  final String name;
  final String officeId;
  final String officeCode;
  final String officeName;
  final String officeType;
  final String nik;
  final String phone;
  final String employeeStatus;
  final String department;
  final String division;
  final String position;
  final String level;
  final String photo;

  static String _text(dynamic value) {
    if (value == null) return '';
    final text = value.toString().trim();
    return text.toLowerCase() == 'null' ? '' : text;
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final rawOffice = json['office'];
    final office = rawOffice is Map
        ? Map<String, dynamic>.from(rawOffice)
        : <String, dynamic>{};

    return EmployeeModel(
      id: _text(json['id']),
      employeeNo: _text(json['employee_no']),
      name: _text(json['name']),
      officeId: _text(office['id']),
      officeCode: _text(office['branch_code']),
      officeName: _text(office['name']),
      officeType: _text(office['branch_type']),
      nik: _text(json['nik']),
      phone: _text(json['phone']),
      employeeStatus: _text(json['employee_status']),
      department: _text(json['department']),
      division: _text(json['division']),
      position: _text(json['position']),
      level: _text(json['level']),
      photo: _text(json['photo']),
    );
  }
}
