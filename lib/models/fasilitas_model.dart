import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class FasilitasModel {

  const FasilitasModel({
    required this.modul,
    required this.menu,
    required this.submenu,
    required this.urut,
  });

  final String modul;
  final String menu;
  final String submenu;
  final String urut;

  factory FasilitasModel.fromJson(Map<String,dynamic> json) => FasilitasModel(
    modul: json['modul'].toString(),
    menu: json['menu'].toString(),
    submenu: json['submenu'].toString(),
    urut: json['urut'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'modul': modul,
    'menu': menu,
    'submenu': submenu,
    'urut': urut
  };

  FasilitasModel clone() => FasilitasModel(
    modul: modul,
    menu: menu,
    submenu: submenu,
    urut: urut
  );


  FasilitasModel copyWith({
    String? modul,
    String? menu,
    String? submenu,
    String? urut
  }) => FasilitasModel(
    modul: modul ?? this.modul,
    menu: menu ?? this.menu,
    submenu: submenu ?? this.submenu,
    urut: urut ?? this.urut,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is FasilitasModel && modul == other.modul && menu == other.menu && submenu == other.submenu && urut == other.urut;

  @override
  int get hashCode => modul.hashCode ^ menu.hashCode ^ submenu.hashCode ^ urut.hashCode;
}
