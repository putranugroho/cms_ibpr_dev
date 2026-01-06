import 'package:cms_ibpr/module/account_type/account_type_page.dart';
import 'package:cms_ibpr/module/dashboard/dashboard_page.dart';
import 'package:cms_ibpr/module/kantor/kantor_page.dart';
import 'package:cms_ibpr/module/laporan/laporan_page.dart';
import 'package:cms_ibpr/module/limit/limit_page.dart';
import 'package:cms_ibpr/module/menu/menu_notifier.dart';
import 'package:cms_ibpr/module/mpin/cetak_mpin_page.dart';
import 'package:cms_ibpr/module/mpin/ganti_mpin_page.dart';
import 'package:cms_ibpr/module/mpin/generated_mpin_page.dart';

import 'package:cms_ibpr/module/mpin/regenerated_mpin_page.dart';
import 'package:cms_ibpr/module/mpin/reset_mpin_page.dart';
import 'package:cms_ibpr/module/nasabah/blokir_nasabah_page.dart';
import 'package:cms_ibpr/module/nasabah/daftar_kartu_page.dart';
import 'package:cms_ibpr/module/nasabah/foto_nasabah_collme_page.dart';
import 'package:cms_ibpr/module/nasabah/nasabah_page.dart';
import 'package:cms_ibpr/module/nasabah/tutup_nasabah_page.dart';
import 'package:cms_ibpr/module/nasabah/unblokir_nasabah_page.dart';
import 'package:cms_ibpr/module/users_access/users_access_page.dart';
import 'package:cms_ibpr/utils/colors.dart';
import 'package:cms_ibpr/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuNotifier(context: context),
      child: Consumer<MenuNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              value.isloading
                  ? SizedBox()
                  : Container(
                      width: 240,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: colorPrimary),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "CMS",
                            style: TextStyle(
                              fontFamily: "Arial Black",
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            "Customer Management System",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          value.isloading
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: const Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "${value.users!.namaUsers} ",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "(${value.users!.usersId} - ${value.users!.bprId})",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )),
                                        IconButton(
                                            onPressed: () =>
                                                value.confirmDelete(),
                                            icon: const Icon(
                                              Icons.power_settings_new,
                                              color: Colors.white,
                                              size: 30,
                                            ))
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () => value.gantipassword(),
                                      child: const Text(
                                        "Ganti Password",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 16),
                                    //   child: Row(
                                    //     children: [
                                    //       const Expanded(
                                    //         child: Text(
                                    //           "Ganti Password",
                                    //           style: TextStyle(
                                    //               color: Colors.white,
                                    //               fontWeight:
                                    //                   FontWeight.normal),
                                    //         ),
                                    //       ),
                                    //       IconButton(
                                    //           onPressed: () =>
                                    //               value.gantipassword(),
                                    //           icon: const Icon(
                                    //             Icons.key_outlined,
                                    //             color: Colors.white,
                                    //             size: 30,
                                    //           ))
                                    //     ],
                                    //   ),
                                    // ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: const Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 16,
                          ),
                          value.listFasilitas
                                  .where((e) => e.menu == "DASHBOARD")
                                  .isNotEmpty
                              ? InkWell(
                                  onTap: () => value.gantipage(0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.dashboard,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Dashboard",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 0
                                                    ? FontWeight.w900
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) =>
                                      e.menu == "SETUP" &&
                                      e.submenu == "KANTOR")
                                  .isNotEmpty
                              ? InkWell(
                                  onTap: () => value.gantipage(3),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.kantor,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Kantor",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 3
                                                    ? FontWeight.w900
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) =>
                                      e.menu == "SETUP" &&
                                      e.submenu == "USER ACCESS")
                                  .isNotEmpty
                              ? InkWell(
                                  onTap: () => value.gantipage(1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.user,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "User Access",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 1
                                                    ? FontWeight.w900
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) =>
                                      e.menu == "SETUP" &&
                                      e.submenu == "ACCOUNT TYPE")
                                  .isNotEmpty
                              ? InkWell(
                                  onTap: () => value.gantipage(5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.user,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Account Type",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 5
                                                    ? FontWeight.w900
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) =>
                                      e.menu == "SETUP" &&
                                      e.submenu == "SETUP LIMIT")
                                  .isNotEmpty
                              ? InkWell(
                                  onTap: () => value.gantipage(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.user,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Setup Limit ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 6
                                                    ? FontWeight.w900
                                                    : FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) =>
                                      e.menu == "AKUN" &&
                                      (e.submenu == "DATA NASABAH" ||
                                          e.submenu == "BLOKIR NASABAH" ||
                                          e.submenu == "UNBLOKIR NASABAH" ||
                                          e.submenu == "DAFTAR KARTU" ||
                                          e.submenu == "UPDATE FOTO LEWAT WEB" ||
                                          e.submenu == "TUTUP AKUN IBPR"))
                                  .isNotEmpty
                              ? ExpansionTile(
                                  tilePadding: const EdgeInsets.all(0),
                                  childrenPadding: const EdgeInsets.all(0),
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.user,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        const Expanded(
                                          child: Text(
                                            "Nasabah",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "AKUN" &&
                                                    e.submenu == "DATA NASABAH")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () => value.gantipage(2),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Data Nasabah",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 2
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "AKUN" &&
                                                    e.submenu == "UPDATE FOTO LEWAT WEB")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () =>
                                                    value.gantipage(15),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Update Foto lewat Web",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 15
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "AKUN" &&
                                                    e.submenu == "DAFTAR KARTU")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () =>
                                                    value.gantipage(11),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Daftar Kartu",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 11
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "AKUN" &&
                                                    e.submenu ==
                                                        "BLOKIR NASABAH")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () =>
                                                    value.gantipage(10),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Blokir Nasabah",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 10
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "AKUN" &&
                                                    e.submenu ==
                                                        "UNBLOKIR NASABAH")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () =>
                                                    value.gantipage(12),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Unblokir Nasabah",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 12
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "AKUN" &&
                                                    e.submenu ==
                                                        "TUTUP AKUN IBPR")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () =>
                                                    value.gantipage(13),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    // "Tutup Akun IBPR",
                                                    "Tutup Akun Nasabah",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 13
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    )
                                  ],
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) =>
                                      e.menu == "MPIN" &&
                                      (e.submenu == "GENERATE MPIN" ||
                                          e.submenu == "RESET MPIN" ||
                                          e.submenu == "KIRIM MPIN" ||
                                          e.submenu == "CETAK MPIN"))
                                  .isNotEmpty
                              ? ExpansionTile(
                                  tilePadding: const EdgeInsets.all(0),
                                  childrenPadding: const EdgeInsets.all(0),
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.mpin,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        const Expanded(
                                          child: Text(
                                            "MPIN",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "MPIN" &&
                                                    e.submenu ==
                                                        "GENERATE MPIN")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () => value.gantipage(4),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Generated MPIN",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 4
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "MPIN" &&
                                                    e.submenu == "CETAK MPIN")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () => value.gantipage(7),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Cetak MPIN",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 7
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "MPIN" &&
                                                    e.submenu ==
                                                        "GENERATE MPIN")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () => value.gantipage(8),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Regenerated MPIN",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 8
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "MPIN" &&
                                                    e.submenu == "RESET MPIN")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () =>
                                                    value.gantipage(14),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Reset MPIN",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 14
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        value.listFasilitas
                                                .where((e) =>
                                                    e.menu == "MPIN" &&
                                                    e.submenu == "GANTI MPIN")
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () => value.gantipage(9),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Text(
                                                    "Ganti MPIN",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          value.page == 9
                                                              ? FontWeight.bold
                                                              : FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox()
                                      ],
                                    )
                                  ],
                                )
                              : SizedBox(),
                          value.listFasilitas
                                  .where((e) => e.menu == "LAPORAN")
                                  .isNotEmpty
                              ? ExpansionTile(
                                  tilePadding: const EdgeInsets.all(0),
                                  childrenPadding: const EdgeInsets.all(0),
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ImageAssets.report,
                                          color: Colors.white,
                                          height: 24,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        const Expanded(
                                          child: Text(
                                            "Laporan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: const Text(
                                        "Laporan Harian",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
              Expanded(
                  child: value.page == 0
                      ? const DashboardPage()
                      : value.page == 1
                          ? const UsersAccessPage()
                          : value.page == 2
                              ? const NasabahPage()
                              : value.page == 3
                                  ? const KantorPage()
                                  : value.page == 4
                                      ? const GeneratedMPINPage()
                                      : value.page == 5
                                          ? const AccountTypePage()
                                          : value.page == 6
                                              ? const LimitPage()
                                              : value.page == 7
                                                  ? const CetakMPINPage()
                                                  : value.page == 8
                                                      ? const RegeneratedMPINPage()
                                                      : value.page == 9
                                                          ? const GantiMPINPage()
                                                          : value.page == 10
                                                              ? const BlokirNasabahPage()
                                                              : value.page == 12
                                                                  ? const UnBlokirNasabahPage()
                                                                  : value.page ==
                                                                          11
                                                                      ? const DaftarKartuPage()
                                                                      : value.page ==
                                                                              13
                                                                          ? const TutupNasabahPage()
                                                                          : value.page == 14
                                                                              ? const ResetMPINPage()
                                                                              : value.page == 15
                                                                                  ? const FotoNasabahCollmePage()
                                                                                  : const LaporanPage()),
            ],
          ),
        )),
      ),
    );
  }
}
