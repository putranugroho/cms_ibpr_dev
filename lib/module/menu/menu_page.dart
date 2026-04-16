import 'package:cms_ibpr/module/account_type/account_type_page.dart';
import 'package:cms_ibpr/module/dashboard/dashboard_page.dart';
import 'package:cms_ibpr/module/journal/setup_journal_transaksi_page.dart';
import 'package:cms_ibpr/module/kantor/kantor_page.dart';
import 'package:cms_ibpr/module/laporan/laporan_page.dart';
import 'package:cms_ibpr/module/limit/limit_page.dart';
import 'package:cms_ibpr/module/menu/menu_notifier.dart';
import 'package:cms_ibpr/module/mobile_info/mobile_info_nasabah_page.dart';
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
import 'package:cms_ibpr/module/nasabah/reset_password_nasabah_page.dart';
import 'package:cms_ibpr/module/users_access/users_access_page.dart';
import 'package:cms_ibpr/utils/colors.dart';
import 'package:cms_ibpr/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  bool _hasAccess(
    MenuNotifier value, {
    required String menu,
    required String submenu,
    String? subsubmenu,
  }) {
    return value.listFasilitas.any((e) {
      final sameMenu = (e.menu).trim().toUpperCase() == menu.trim().toUpperCase();
      final sameSubmenu = (e.submenu).trim().toUpperCase() == submenu.trim().toUpperCase();
      final sameSubsubmenu = subsubmenu == null ? true : (e.subsubmenu).trim().toUpperCase() == subsubmenu.trim().toUpperCase();
      final enabled = (e.flag).trim().toUpperCase() == "TRUE";

      return sameMenu && sameSubmenu && sameSubsubmenu && enabled;
    });
  }

  bool _hasAnySubsubmenu(
    MenuNotifier value, {
    required String menu,
    required String submenu,
    required List<String> subsubmenus,
  }) {
    return value.listFasilitas.any((e) {
      final sameMenu = (e.menu).trim().toUpperCase() == menu.trim().toUpperCase();
      final sameSubmenu = (e.submenu).trim().toUpperCase() == submenu.trim().toUpperCase();
      final enabled = (e.flag).trim().toUpperCase() == "TRUE";
      final matchedSubsubmenu = subsubmenus.any(
        (s) => (e.subsubmenu).trim().toUpperCase() == s.trim().toUpperCase(),
      );

      return sameMenu && sameSubmenu && matchedSubsubmenu && enabled;
    });
  }

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
                    ? const SizedBox()
                    : Container(
                        width: 240,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(color: colorPrimary),
                        child: ListView(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              "CMS",
                              style: TextStyle(
                                fontFamily: "Arial Black",
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Customer Management System",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            value.isloading
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: const Divider(color: Colors.grey),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  "${value.users!.namaUsers} ",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "(${value.users!.usersId} - ${value.users!.bprId})",
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => value.confirmDelete(),
                                            icon: const Icon(
                                              Icons.power_settings_new,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () => value.gantipassword(),
                                        child: const Text(
                                          "Ganti Password",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: const Divider(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 16),

                            // DASHBOARD
                            value.listFasilitas.any(
                              (e) => (e.menu).trim().toUpperCase() == "DASHBOARD" && (e.flag).trim().toUpperCase() == "TRUE",
                            )
                                ? InkWell(
                                    onTap: () => value.gantipage(0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.dashboard,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Dashboard",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 0 ? FontWeight.w900 : FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            // KANTOR
                            _hasAccess(
                              value,
                              menu: "SETUP",
                              submenu: "KANTOR",
                            )
                                ? InkWell(
                                    onTap: () => value.gantipage(3),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.kantor,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Kantor",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 3 ? FontWeight.w900 : FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            // USER ACCESS
                            _hasAccess(
                              value,
                              menu: "SETUP",
                              submenu: "USER ACCESS",
                            )
                                ? InkWell(
                                    onTap: () => value.gantipage(1),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.user,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "User Access",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 1 ? FontWeight.w900 : FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            // ACCOUNT TYPE
                            _hasAccess(
                              value,
                              menu: "SETUP",
                              submenu: "ACCOUNT TYPE",
                            )
                                ? InkWell(
                                    onTap: () => value.gantipage(5),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.user,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Account Type",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 5 ? FontWeight.w900 : FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            // SETUP LIMIT
                            _hasAccess(
                              value,
                              menu: "SETUP",
                              submenu: "SETUP LIMIT",
                            )
                                ? InkWell(
                                    onTap: () => value.gantipage(6),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.user,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Setup Limit ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 6 ? FontWeight.w900 : FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            // SETUP LIMIT
                            _hasAccess(
                              value,
                              menu: "SETUP",
                              submenu: "SETUP LIMIT",
                            )
                                ? InkWell(
                                    onTap: () => value.gantipage(18),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.user,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Setup Journal Transaksi",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: value.page == 6 ? FontWeight.w900 : FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            // IBPR
                            _hasAccess(
                              value,
                              menu: "AKUN",
                              submenu: "DATA NASABAH",
                            )
                                ? ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    title: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.user,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              "IBPR",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(2),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Data Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 2 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "DAFTAR KARTU",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(11),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Daftar Kartu",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 11 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "BLOKIR",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(10),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Blokir Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 10 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "BUKA BLOKIR",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(12),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Unblokir Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 12 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "BUKA BLOKIR",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(17),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Reset Password Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 12 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "TUTUP AKUN IBPR",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(13),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Tutup Akun Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 13 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),

                                          // Hanya tampil jika backend memang kirim menu ini
                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "UPDATE FOTO LEWAT WEB",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(15),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Update Foto lewat Web",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 15 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox(),

                            // MOBILE INFO
                            _hasAccess(
                              value,
                              menu: "AKUN",
                              submenu: "DATA NASABAH",
                            )
                                ? ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    title: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.user,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              "MOBILE INFO",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(16),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Data Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 16 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          _hasAccess(
                                            value,
                                            menu: "AKUN",
                                            submenu: "DATA NASABAH",
                                            subsubmenu: "TUTUP AKUN IBPR",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(13),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Tutup Akun Nasabah",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 13 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox(),

                            // MPIN
                            _hasAnySubsubmenu(
                                      value,
                                      menu: "MPIN",
                                      submenu: "GENERATE MPIN",
                                      subsubmenus: const ["GENERATE MPIN"],
                                    ) ||
                                    _hasAnySubsubmenu(
                                      value,
                                      menu: "MPIN",
                                      submenu: "CETAK MPIN",
                                      subsubmenus: const ["CETAK MPIN"],
                                    ) ||
                                    _hasAnySubsubmenu(
                                      value,
                                      menu: "MPIN",
                                      submenu: "REGENERATE MPIN",
                                      subsubmenus: const ["REGENERATE MPIN"],
                                    ) ||
                                    _hasAnySubsubmenu(
                                      value,
                                      menu: "MPIN",
                                      submenu: "RESET MPIN",
                                      subsubmenus: const ["RESET MPIN"],
                                    ) ||
                                    _hasAnySubsubmenu(
                                      value,
                                      menu: "MPIN",
                                      submenu: "GANTI MPIN",
                                      subsubmenus: const ["GANTI MPIN"],
                                    )
                                ? ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    title: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.mpin,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              "MPIN",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          _hasAccess(
                                            value,
                                            menu: "MPIN",
                                            submenu: "GENERATE MPIN",
                                            subsubmenu: "GENERATE MPIN",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(4),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Generated MPIN",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 4 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          _hasAccess(
                                            value,
                                            menu: "MPIN",
                                            submenu: "CETAK MPIN",
                                            subsubmenu: "CETAK MPIN",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(7),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Cetak MPIN",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 7 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          _hasAccess(
                                            value,
                                            menu: "MPIN",
                                            submenu: "REGENERATE MPIN",
                                            subsubmenu: "REGENERATE MPIN",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(8),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Regenerated MPIN",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 8 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          _hasAccess(
                                            value,
                                            menu: "MPIN",
                                            submenu: "RESET MPIN",
                                            subsubmenu: "RESET MPIN",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(14),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Reset MPIN",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 14 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          _hasAccess(
                                            value,
                                            menu: "MPIN",
                                            submenu: "GANTI MPIN",
                                            subsubmenu: "GANTI MPIN",
                                          )
                                              ? InkWell(
                                                  onTap: () => value.gantipage(9),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                    child: Text(
                                                      "Ganti MPIN",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: value.page == 9 ? FontWeight.bold : FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox(),

                            // LAPORAN
                            _hasAccess(
                              value,
                              menu: "LAPORAN",
                              submenu: "LAPORAN HARIAN",
                              subsubmenu: "LAPORAN HARIAN",
                            )
                                ? ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    title: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageAssets.report,
                                            color: Colors.white,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              "Laporan",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: const Text(
                                          "Laporan Harian",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox(),
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
                                                                  : value.page == 11
                                                                      ? const DaftarKartuPage()
                                                                      : value.page == 13
                                                                          ? const TutupNasabahPage()
                                                                          : value.page == 14
                                                                              ? const ResetMPINPage()
                                                                              : value.page == 15
                                                                                  ? const FotoNasabahCollmePage()
                                                                                  : value.page == 16
                                                                                      ? const UsersInfoPage()
                                                                                      : value.page == 17
                                                                                          ? const ResetPasswordNasabahPage()
                                                                                          : value.page == 18
                                                                                              ? const SetupJournalTransaksiPage()
                                                                                              : const LaporanPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
