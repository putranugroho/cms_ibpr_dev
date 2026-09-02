import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/kantor/kantor_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/colors.dart';
import '../../utils/pro_shimmer.dart';

class KantorPage extends StatelessWidget {
  const KantorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KantorNotifier(context: context),
      child: Consumer<KantorNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Kantor HRIS',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Refresh',
                        onPressed: value.isLoading ? null : value.getKantor,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(value)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(KantorNotifier value) {
    if (value.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProShimmer(height: 10, width: 200),
            SizedBox(height: 4),
            ProShimmer(height: 10, width: 120),
            SizedBox(height: 4),
            ProShimmer(height: 10, width: 100),
          ],
        ),
      );
    }

    if (value.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value.errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: value.getKantor,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (value.list.isEmpty) {
      return const Center(child: Text('Data kantor HRIS tidak ditemukan'));
    }

    return RefreshIndicator(
      onRefresh: value.getKantor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SfDataGrid(
          headerRowHeight: 60,
          rowHeight: 64,
          defaultColumnWidth: 150,
          frozenColumnsCount: 2,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          source: KantorDataSource(value.list),
          columns: [
            _column('no', 'No', width: 60),
            _column('branch_code', 'Kode Kantor', width: 140),
            _column('name', 'Nama Kantor', width: 220),
            _column('branch_type', 'Tipe', width: 120),
            _column('is_default', 'Default', width: 100),
            _column('employee_count', 'Pegawai', width: 100),
            _column('address', 'Alamat', width: 360),
            _column('phone', 'Telepon', width: 160),
            _column('email', 'Email', width: 220),
          ],
        ),
      ),
    );
  }

  GridColumn _column(String name, String label, {double width = 150}) {
    return GridColumn(
      width: width,
      columnName: name,
      label: Container(
        color: colorPrimary,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class KantorDataSource extends DataGridSource {
  KantorDataSource(List<KantorModel> list) {
    var index = 1;
    _rows = list.map((data) {
      final row = DataGridRow(
        cells: [
          DataGridCell<String>(columnName: 'no', value: index.toString()),
          DataGridCell<String>(columnName: 'branch_code', value: data.kdKantor.toString()),
          DataGridCell<String>(columnName: 'name', value: data.namaKantor.toString()),
          DataGridCell<String>(columnName: 'branch_type', value: data.branchType),
          DataGridCell<String>(columnName: 'is_default', value: data.isDefault ? 'Ya' : 'Tidak'),
          DataGridCell<String>(columnName: 'employee_count', value: data.employeeCount.toString()),
          DataGridCell<String>(columnName: 'address', value: data.address),
          DataGridCell<String>(columnName: 'phone', value: data.phone),
          DataGridCell<String>(columnName: 'email', value: data.email),
        ],
      );
      index++;
      return row;
    }).toList();
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          alignment: cell.columnName == 'no' || cell.columnName == 'is_default' || cell.columnName == 'employee_count'
              ? Alignment.center
              : Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            (cell.value ?? '').toString(),
            maxLines: cell.columnName == 'address' ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
