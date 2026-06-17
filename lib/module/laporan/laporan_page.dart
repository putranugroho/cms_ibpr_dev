import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/laporan/laporan_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:cms_ibpr/utils/colors.dart';
import 'package:cms_ibpr/utils/pro_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LaporanUserAccessPage();
  }
}

class LaporanUserAccessPage extends StatelessWidget {
  const LaporanUserAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _LaporanSinglePage(
      initialReport: "user_access",
      title: "Laporan User Access",
      subtitle: "Daftar user access aktif. Status Hapus tidak ditampilkan.",
      builder: (value) => _UserAccessReportTab(value: value),
    );
  }
}

class LaporanAkunIbprPage extends StatelessWidget {
  const LaporanAkunIbprPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _LaporanSinglePage(
      initialReport: "akun_ibpr",
      title: "Laporan Akun IBPR",
      subtitle: "Filter status dan tanggal akun IBPR.",
      builder: (value) => _AkunIbprReportTab(value: value),
    );
  }
}

class LaporanTransaksiPage extends StatelessWidget {
  const LaporanTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _LaporanSinglePage(
      initialReport: "transaksi",
      title: "Laporan Transaksi",
      subtitle: "Filter transaksi per akun atau ALL berdasarkan range tanggal transaksi.",
      builder: (value) => _TransaksiReportTab(value: value),
    );
  }
}

typedef _LaporanBodyBuilder = Widget Function(LaporanNotifier value);

class _LaporanSinglePage extends StatelessWidget {
  const _LaporanSinglePage({
    required this.initialReport,
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final String initialReport;
  final String title;
  final String subtitle;
  final _LaporanBodyBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LaporanNotifier(
        context: context,
        initialReport: initialReport,
      ),
      child: Consumer<LaporanNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 96,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(child: builder(value)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAccessReportTab extends StatelessWidget {
  const _UserAccessReportTab({required this.value});

  final LaporanNotifier value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ReportToolbar(
          title: "List User Access",
          subtitle: "Status Hapus tidak ditampilkan. Data diurutkan berdasarkan status lalu nama user.",
          trailing: ButtonPrimary(
            onTap: () => value.getUserAccessReport(),
            name: "Refresh",
          ),
        ),
        Expanded(
          child: value.isLoadingUserAccess
              ? const _LoadingReport()
              : value.listUserAccess.isEmpty
                  ? const _EmptyReport(message: "Data user access kosong")
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: SfDataGrid(
                        headerRowHeight: 58,
                        rowHeight: 54,
                        defaultColumnWidth: 150,
                        frozenColumnsCount: 2,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        source: UserAccessReportDataSource(value.listUserAccess),
                        columns: [
                          _gridColumn("no", "No", width: 55, align: Alignment.center),
                          _gridColumn("status", "Status", width: 120, align: Alignment.center),
                          _gridColumn("userid", "User ID", width: 160),
                          _gridColumn("namauser", "Nama User", width: 260),
                          _gridColumn("bpr_id", "BPR ID", width: 120),
                          _gridColumn("kdkantor", "Kode Kantor", width: 130),
                          _gridColumn("nama_kantor", "Nama Kantor", width: 230),
                          _gridColumn("lvluser", "Level", width: 100, align: Alignment.center),
                          _gridColumn("stslogin", "Login", width: 100, align: Alignment.center),
                          _gridColumn("tglexp", "Tgl Expired", width: 160),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }
}

class _AkunIbprReportTab extends StatelessWidget {
  const _AkunIbprReportTab({required this.value});

  final LaporanNotifier value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  value: value.akunStatusOptions.contains(value.akunStatus) ? value.akunStatus : "ALL",
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: value.akunStatusOptions
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (e) {
                    if (e != null) value.pilihStatusAkun(e);
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    activeColor: colorPrimary,
                    value: value.akunUseTanggal,
                    onChanged: (e) => value.toggleTanggalAkun(e ?? false),
                  ),
                  const Text("Filter Tanggal"),
                ],
              ),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: value.akunTanggal,
                  enabled: value.akunUseTanggal,
                  readOnly: true,
                  onTap: value.akunUseTanggal ? () => value.pilihTanggalAkun() : null,
                  decoration: const InputDecoration(
                    labelText: "Tanggal",
                    border: OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
              ButtonPrimary(
                onTap: () => value.getAkunIbprReport(),
                name: "Tampilkan",
              ),
              Text(
                "Total: ${value.listAkun.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: value.isLoadingAkun
              ? const _LoadingReport()
              : value.listAkun.isEmpty
                  ? const _EmptyReport(message: "Data akun IBPR kosong")
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: SfDataGrid(
                        headerRowHeight: 58,
                        rowHeight: 54,
                        defaultColumnWidth: 150,
                        frozenColumnsCount: 2,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        source: AkunIbprReportDataSource(value.listAkun),
                        columns: [
                          _gridColumn("no", "No", width: 55, align: Alignment.center),
                          _gridColumn("status", "Status", width: 120, align: Alignment.center),
                          _gridColumn("nama", "Nama User", width: 230),
                          _gridColumn("no_rek", "No Akun/Rek", width: 180),
                          _gridColumn("nama_rek", "Nama Rekening", width: 260),
                          _gridColumn("no_hp", "No HP", width: 170),
                          _gridColumn("no_ktp", "No Identitas", width: 190),
                          _gridColumn("acct_type", "Acct Type", width: 130),
                          _gridColumn("kd_kantor", "Kode Kantor", width: 130),
                          _gridColumn("tgl_data", "Tanggal", width: 160),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }
}

class _TransaksiReportTab extends StatelessWidget {
  const _TransaksiReportTab({required this.value});

  final LaporanNotifier value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 360,
                child: DropdownButtonFormField<String>(
                  value: value.transaksiAkunItems.any((e) => e.value == value.transaksiAkunKey) ? value.transaksiAkunKey : "ALL",
                  decoration: const InputDecoration(
                    labelText: "Akun",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: value.transaksiAkunItems,
                  onChanged: (e) {
                    if (e != null) value.pilihTransaksiAkun(e);
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: value.transaksiTglAwal,
                  readOnly: true,
                  onTap: () => value.pilihTanggalTransaksiAwal(),
                  decoration: const InputDecoration(
                    labelText: "Tgl Awal",
                    border: OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: value.transaksiTglAkhir,
                  readOnly: true,
                  onTap: () => value.pilihTanggalTransaksiAkhir(),
                  decoration: const InputDecoration(
                    labelText: "Tgl Akhir",
                    border: OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
              ButtonPrimary(
                onTap: () => value.getTransaksiReport(),
                name: "Tampilkan",
              ),
              Text(
                "Total: ${value.listTransaksi.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: value.isLoadingTransaksi
              ? const _LoadingReport()
              : value.listTransaksi.isEmpty
                  ? const _EmptyReport(message: "Data transaksi kosong")
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: SfDataGrid(
                        headerRowHeight: 58,
                        rowHeight: 54,
                        defaultColumnWidth: 150,
                        frozenColumnsCount: 2,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        source: TransaksiReportDataSource(value.listTransaksi),
                        columns: [
                          _gridColumn("no", "No", width: 55, align: Alignment.center),
                          _gridColumn("tgl_trans_date", "Tgl Trans", width: 140, align: Alignment.center),
                          _gridColumn("final_status", "Status", width: 120, align: Alignment.center),
                          _gridColumn("trx_category", "Kategori", width: 130),
                          _gridColumn("rrn", "RRN", width: 180),
                          _gridColumn("ref_id", "Ref ID", width: 180),
                          _gridColumn("no_rek", "No Akun/Rek", width: 180),
                          _gridColumn("no_hp", "No HP", width: 170),
                          _gridColumn("product_name", "Produk", width: 230),
                          _gridColumn("amount", "Amount", width: 140, align: Alignment.centerRight),
                          _gridColumn("admin_fee", "Admin", width: 120, align: Alignment.centerRight),
                          _gridColumn("fee_bpr", "Fee BPR", width: 120, align: Alignment.centerRight),
                          _gridColumn("final_code", "Kode", width: 100, align: Alignment.center),
                          _gridColumn("final_message", "Message", width: 300),
                          _gridColumn("duration_ms", "Durasi", width: 120, align: Alignment.centerRight),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }
}

class _ReportToolbar extends StatelessWidget {
  const _ReportToolbar({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _LoadingReport extends StatelessWidget {
  const _LoadingReport();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProShimmer(height: 10, width: 220),
          SizedBox(height: 6),
          ProShimmer(height: 10, width: 160),
          SizedBox(height: 6),
          ProShimmer(height: 10, width: 120),
        ],
      ),
    );
  }
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

GridColumn _gridColumn(
  String name,
  String title, {
  double width = 150,
  Alignment align = Alignment.centerLeft,
}) {
  return GridColumn(
    width: width,
    columnName: name,
    label: Container(
      color: colorPrimary,
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: align == Alignment.centerRight ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class UserAccessReportDataSource extends DataGridSource {
  UserAccessReportDataSource(List<LaporanUserAccessItem> list) {
    int index = 1;
    _data = list.map<DataGridRow>((data) {
      final row = DataGridRow(cells: [
        DataGridCell(columnName: "no", value: index.toString()),
        DataGridCell(columnName: "status", value: data.statusLabel),
        DataGridCell(columnName: "userid", value: data.userid),
        DataGridCell(columnName: "namauser", value: data.namauser),
        DataGridCell(columnName: "bpr_id", value: data.bprId),
        DataGridCell(columnName: "kdkantor", value: data.kdkantor),
        DataGridCell(columnName: "nama_kantor", value: data.namaKantor),
        DataGridCell(columnName: "lvluser", value: data.lvluser),
        DataGridCell(columnName: "stslogin", value: data.stslogin),
        DataGridCell(columnName: "tglexp", value: _formatDate(data.tglexp)),
      ]);
      index++;
      return row;
    }).toList();
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == "status") {
          return _statusCell(cell.value);
        }
        return _textCell(cell.value);
      }).toList(),
    );
  }
}

class AkunIbprReportDataSource extends DataGridSource {
  AkunIbprReportDataSource(List<LaporanAkunIbprItem> list) {
    int index = 1;
    _data = list.map<DataGridRow>((data) {
      final row = DataGridRow(cells: [
        DataGridCell(columnName: "no", value: index.toString()),
        DataGridCell(columnName: "status", value: data.statusLabel),
        DataGridCell(columnName: "nama", value: data.nama),
        DataGridCell(columnName: "no_rek", value: data.noRek),
        DataGridCell(columnName: "nama_rek", value: data.namaRek),
        DataGridCell(columnName: "no_hp", value: data.noHp),
        DataGridCell(columnName: "no_ktp", value: data.noKtp),
        DataGridCell(columnName: "acct_type", value: data.acctType),
        DataGridCell(columnName: "kd_kantor", value: data.kdKantor),
        DataGridCell(columnName: "tgl_data", value: _formatDate(data.tglData)),
      ]);
      index++;
      return row;
    }).toList();
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == "status") {
          return _statusCell(cell.value);
        }
        return _textCell(cell.value);
      }).toList(),
    );
  }
}

class TransaksiReportDataSource extends DataGridSource {
  TransaksiReportDataSource(List<LaporanTrxItem> list) {
    int index = 1;
    _data = list.map<DataGridRow>((data) {
      final row = DataGridRow(cells: [
        DataGridCell(columnName: "no", value: index.toString()),
        DataGridCell(columnName: "tgl_trans_date", value: _formatDate(data.tglTransDate.isNotEmpty ? data.tglTransDate : data.tglTrans)),
        DataGridCell(columnName: "final_status", value: data.finalStatus),
        DataGridCell(columnName: "trx_category", value: data.trxCategory),
        DataGridCell(columnName: "rrn", value: data.rrn),
        DataGridCell(columnName: "ref_id", value: data.refId),
        DataGridCell(columnName: "no_rek", value: data.noRek),
        DataGridCell(columnName: "no_hp", value: data.noHp),
        DataGridCell(columnName: "product_name", value: data.productName),
        DataGridCell(columnName: "amount", value: _formatMoney(data.amount)),
        DataGridCell(columnName: "admin_fee", value: _formatMoney(data.adminFee)),
        DataGridCell(columnName: "fee_bpr", value: _formatMoney(data.feeBpr)),
        DataGridCell(columnName: "final_code", value: data.finalCode),
        DataGridCell(columnName: "final_message", value: data.finalMessage),
        DataGridCell(columnName: "duration_ms", value: "${data.durationMs} ms"),
      ]);
      index++;
      return row;
    }).toList();
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == "final_status") {
          return _statusCell(cell.value);
        }
        final isRight = ["amount", "admin_fee", "fee_bpr", "duration_ms"].contains(cell.columnName);
        return _textCell(
          cell.value,
          alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
          textAlign: isRight ? TextAlign.right : TextAlign.left,
        );
      }).toList(),
    );
  }
}

Widget _textCell(
  dynamic value, {
  Alignment alignment = Alignment.centerLeft,
  TextAlign textAlign = TextAlign.left,
}) {
  return Container(
    alignment: alignment,
    padding: const EdgeInsets.all(8),
    child: Text(
      (value ?? "-").toString().trim().isEmpty ? "-" : value.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    ),
  );
}

Widget _statusCell(dynamic value) {
  final text = (value ?? "-").toString().trim().isEmpty ? "-" : value.toString().trim().toUpperCase();
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );
}

String _formatDate(String value) {
  final raw = value.trim();
  if (raw.isEmpty || raw == "-") return "-";

  try {
    final normalized = raw.contains("T") ? raw : raw.replaceFirst(" ", "T");
    return DateFormat("dd MMM yyyy").format(DateTime.parse(normalized));
  } catch (_) {
    if (raw.length >= 10) return raw.substring(0, 10);
    return raw;
  }
}

String _formatMoney(double value) {
  final formatter = NumberFormat("#,##0", "en_US");
  return formatter.format(value);
}
