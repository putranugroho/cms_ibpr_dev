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
import 'package:cms_ibpr/module/nasabah/reset_password_nasabah_page.dart';
import 'package:cms_ibpr/module/nasabah/tutup_nasabah_page.dart';
import 'package:cms_ibpr/module/nasabah/unblokir_nasabah_page.dart';
import 'package:cms_ibpr/module/users_access/users_access_page.dart';
import 'package:cms_ibpr/pref/pref.dart';
import 'package:cms_ibpr/utils/auto_logout_wrapper.dart';
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

  Widget _sidebarItem({
    required String title,
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withOpacity(0.18) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? Colors.white.withOpacity(0.55) : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  icon,
                  color: Colors.white,
                  height: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isActive ? FontWeight.w900 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sidebarSubItem({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withOpacity(0.16) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sidebarExpansionTitle({
    required String title,
    required String icon,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? Colors.white.withOpacity(0.45) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            icon,
            color: Colors.white,
            height: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage(int page) {
    if (page == 0) return const DashboardPage();
    if (page == 1) return const UsersAccessPage();
    if (page == 2) return const NasabahPage();
    if (page == 3) return const KantorPage();
    if (page == 4) return const GeneratedMPINPage();
    if (page == 5) return const AccountTypePage();
    if (page == 6) return const LimitPage();
    if (page == 7) return const CetakMPINPage();
    if (page == 8) return const RegeneratedMPINPage();
    if (page == 9) return const GantiMPINPage();
    if (page == 10) return const BlokirNasabahPage();
    if (page == 11) return const DaftarKartuPage();
    if (page == 12) return const UnBlokirNasabahPage();
    if (page == 13) return const TutupNasabahPage();
    if (page == 14) return const ResetMPINPage();
    if (page == 15) return const FotoNasabahCollmePage();
    if (page == 16) return const UsersInfoPage();
    if (page == 17) return const ResetPasswordNasabahPage();
    if (page == 18) return const SetupJournalTransaksiPage();

    return const LaporanPage();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuNotifier(context: context),
      child: Consumer<MenuNotifier>(
        builder: (context, value, child) {
          final isIbprActive = [2, 10, 12, 13, 15, 17].contains(value.page);
          final isMpinActive = [4, 7, 8, 14].contains(value.page);
          final isLaporanActive = value.page == 19;

          return AutoLogoutWrapper(
            idleDuration: Pref.idleDuration,
            onIdleTimeout: value.autoLogoutByIdle,
            child: SafeArea(
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
                                  "CMS iBPR",
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
                                const SizedBox(height: 4),
                                const Text(
                                  "last update 09/06/26 09:00",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
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
                                    const SizedBox(height: 12),
                                    InkWell(
                                      onTap: (value.isSigninSignoffLoading || value.isStatusCoreLoading || !value.isCoreStatusAvailable)
                                          ? null
                                          : () => value.confirmSigninSignoff(),
                                      child: Opacity(
                                        opacity: (value.isStatusCoreLoading || !value.isCoreStatusAvailable) ? 0.75 : 1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: !value.isCoreStatusAvailable
                                                ? Colors.grey.shade800
                                                : value.isCoreSignin
                                                    ? Colors.green.shade700
                                                    : Colors.red.shade700,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: !value.isCoreStatusAvailable
                                                  ? Colors.grey.shade500
                                                  : value.isCoreSignin
                                                      ? Colors.greenAccent
                                                      : Colors.redAccent,
                                              width: 1.4,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                !value.isCoreStatusAvailable
                                                    ? Icons.block
                                                    : value.isCoreSignin
                                                        ? Icons.lock_open
                                                        : Icons.lock,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  value.isStatusCoreLoading
                                                      ? "CHECKING CORE..."
                                                      : !value.isCoreStatusAvailable
                                                          ? "CORE UNKNOWN"
                                                          : value.isCoreSignin
                                                              ? "CORE SIGN IN"
                                                              : "CORE SIGN OFF",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              if (value.isSigninSignoffLoading || value.isStatusCoreLoading)
                                                const SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              else
                                                Icon(
                                                  !value.isCoreStatusAvailable ? Icons.error_outline : Icons.sync_alt,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: const Divider(color: Colors.grey),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // DASHBOARD
                                value.listFasilitas.any(
                                  (e) => (e.menu).trim().toUpperCase() == "DASHBOARD" && (e.flag).trim().toUpperCase() == "TRUE",
                                )
                                    ? _sidebarItem(
                                        title: "Dashboard",
                                        icon: ImageAssets.dashboard,
                                        isActive: value.page == 0,
                                        onTap: () => value.gantipage(0),
                                      )
                                    : const SizedBox(),

                                // KANTOR
                                _hasAccess(
                                  value,
                                  menu: "SETUP",
                                  submenu: "KANTOR",
                                )
                                    ? _sidebarItem(
                                        title: "Kantor",
                                        icon: ImageAssets.kantor,
                                        isActive: value.page == 3,
                                        onTap: () => value.gantipage(3),
                                      )
                                    : const SizedBox(),

                                // USER ACCESS
                                _hasAccess(
                                  value,
                                  menu: "SETUP",
                                  submenu: "USER ACCESS",
                                )
                                    ? _sidebarItem(
                                        title: "User Access",
                                        icon: ImageAssets.user,
                                        isActive: value.page == 1,
                                        onTap: () => value.gantipage(1),
                                      )
                                    : const SizedBox(),

                                // ACCOUNT TYPE
                                _hasAccess(
                                  value,
                                  menu: "SETUP",
                                  submenu: "ACCOUNT TYPE",
                                )
                                    ? _sidebarItem(
                                        title: "Account Type",
                                        icon: ImageAssets.user,
                                        isActive: value.page == 5,
                                        onTap: () => value.gantipage(5),
                                      )
                                    : const SizedBox(),

                                // SETUP LIMIT
                                _hasAccess(
                                  value,
                                  menu: "SETUP",
                                  submenu: "SETUP LIMIT",
                                )
                                    ? _sidebarItem(
                                        title: "Setup Limit",
                                        icon: ImageAssets.user,
                                        isActive: value.page == 6,
                                        onTap: () => value.gantipage(6),
                                      )
                                    : const SizedBox(),

                                // SETUP JOURNAL TRANSAKSI
                                _hasAccess(
                                  value,
                                  menu: "SETUP",
                                  submenu: "SETUP LIMIT",
                                )
                                    ? _sidebarItem(
                                        title: "Setup Journal Transaksi",
                                        icon: ImageAssets.user,
                                        isActive: value.page == 18,
                                        onTap: () => value.gantipage(18),
                                      )
                                    : const SizedBox(),

                                // IBPR
                                _hasAccess(
                                  value,
                                  menu: "AKUN",
                                  submenu: "DATA NASABAH",
                                )
                                    ? ExpansionTile(
                                        initiallyExpanded: isIbprActive,
                                        tilePadding: EdgeInsets.zero,
                                        childrenPadding: EdgeInsets.zero,
                                        iconColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        title: _sidebarExpansionTitle(
                                          title: "IBPR",
                                          icon: ImageAssets.user,
                                          isActive: isIbprActive,
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
                                                  ? _sidebarSubItem(
                                                      title: "Kelola Akun",
                                                      isActive: value.page == 2,
                                                      onTap: () => value.gantipage(2),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "AKUN",
                                                submenu: "DATA NASABAH",
                                                subsubmenu: "BLOKIR",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Blokir Akun",
                                                      isActive: value.page == 10,
                                                      onTap: () => value.gantipage(10),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "AKUN",
                                                submenu: "DATA NASABAH",
                                                subsubmenu: "BUKA BLOKIR",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Unblokir Akun",
                                                      isActive: value.page == 12,
                                                      onTap: () => value.gantipage(12),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "AKUN",
                                                submenu: "DATA NASABAH",
                                                subsubmenu: "BUKA BLOKIR",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Reset Password Akun",
                                                      isActive: value.page == 17,
                                                      onTap: () => value.gantipage(17),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "AKUN",
                                                submenu: "DATA NASABAH",
                                                subsubmenu: "TUTUP AKUN IBPR",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Tutup Akun",
                                                      isActive: value.page == 13,
                                                      onTap: () => value.gantipage(13),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "AKUN",
                                                submenu: "DATA NASABAH",
                                                subsubmenu: "UPDATE FOTO LEWAT WEB",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Update Foto lewat Web",
                                                      isActive: value.page == 15,
                                                      onTap: () => value.gantipage(15),
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
                                        )
                                    ? ExpansionTile(
                                        initiallyExpanded: isMpinActive,
                                        tilePadding: EdgeInsets.zero,
                                        childrenPadding: EdgeInsets.zero,
                                        iconColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        title: _sidebarExpansionTitle(
                                          title: "MPIN",
                                          icon: ImageAssets.mpin,
                                          isActive: isMpinActive,
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
                                                  ? _sidebarSubItem(
                                                      title: "Generated MPIN",
                                                      isActive: value.page == 4,
                                                      onTap: () => value.gantipage(4),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "MPIN",
                                                submenu: "CETAK MPIN",
                                                subsubmenu: "CETAK MPIN",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Cetak MPIN",
                                                      isActive: value.page == 7,
                                                      onTap: () => value.gantipage(7),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "MPIN",
                                                submenu: "REGENERATE MPIN",
                                                subsubmenu: "REGENERATE MPIN",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Regenerated MPIN",
                                                      isActive: value.page == 8,
                                                      onTap: () => value.gantipage(8),
                                                    )
                                                  : const SizedBox(),
                                              _hasAccess(
                                                value,
                                                menu: "MPIN",
                                                submenu: "RESET MPIN",
                                                subsubmenu: "RESET MPIN",
                                              )
                                                  ? _sidebarSubItem(
                                                      title: "Reset MPIN",
                                                      isActive: value.page == 14,
                                                      onTap: () => value.gantipage(14),
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
                                        initiallyExpanded: isLaporanActive,
                                        tilePadding: EdgeInsets.zero,
                                        childrenPadding: EdgeInsets.zero,
                                        iconColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        title: _sidebarExpansionTitle(
                                          title: "Laporan",
                                          icon: ImageAssets.report,
                                          isActive: isLaporanActive,
                                        ),
                                        children: [
                                          _sidebarSubItem(
                                            title: "Laporan Harian",
                                            isActive: isLaporanActive,
                                            onTap: () => value.gantipage(19),
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                    Expanded(
                      child: _buildCurrentPage(value.page),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
