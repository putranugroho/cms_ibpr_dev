import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/users_access/users_access_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/colors.dart';
import '../../utils/pro_shimmer.dart';

class UsersAccessPage extends StatelessWidget {
  const UsersAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersAccessNotifier(context: context),
      child: Consumer<UsersAccessNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            key: value.key,
            endDrawer: Drawer(
              width: 600,
              child: Form(
                key: value.keyForm,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    const Text(
                      "Kantor ",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    DropdownButton(
                      isExpanded: true,
                      value: value.kantorModel,
                      items: value.listKantor
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  "(${e.bpr_id} - ${e.kdKantor}) ${e.namaKantor}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (e) {
                        value.pilihKantor(e!);
                      },
                    ),
                    if (value.kantorError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        value.kantorError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      "Nama Users ",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.namaUsers,
                      validator: (e) {
                        final text = (e ?? '').trim();
                        if (text.isEmpty) {
                          return "Nama users wajib diisi";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Username ",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.username,
                      validator: (e) {
                        final text = (e ?? '').trim();
                        if (text.isEmpty) {
                          return "Username wajib diisi";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Password ",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      obscureText: value.obscure,
                      controller: value.password,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            value.gantiobscure();
                          },
                          icon: value.obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        ),
                      ),
                      validator: (e) {
                        final text = (e ?? '').trim();
                        if (text.isEmpty) {
                          return "Password wajib diisi";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tanggal Kadaluarsa ",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () => value.gantiTanggal(),
                      child: TextFormField(
                        controller: value.tglKadaluarsa,
                        enabled: false,
                        validator: (e) {
                          final text = (e ?? '').trim();
                          if (text.isEmpty) {
                            return "Tanggal kadaluarsa wajib diisi";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Fasilitas",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    value.listFasilitas.isNotEmpty
                        ? ListView.builder(
                            itemCount: value.listFasilitas.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              final data = value.listFasilitas[i];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: colorPrimary,
                                        value: value.listAddFasilitas.isEmpty
                                            ? false
                                            : value.listAddFasilitas.any(
                                                (element) =>
                                                    (element.modul ?? "") == (data.modul ?? "") &&
                                                    (element.menu ?? "") == (data.menu ?? "") &&
                                                    (element.submenu ?? "") == (data.submenu ?? "") &&
                                                    (element.urut ?? "") == (data.urut ?? ""),
                                              ),
                                        onChanged: (e) {
                                          value.addFasilitas(data);
                                        },
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text("${data.menu}"),
                                      ),
                                      Expanded(
                                        child: Text("${data.submenu}"),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text("${data.menu}"),
                                      ),
                                      Expanded(
                                        child: Text("${data.subsubmenu}"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              );
                            },
                          )
                        : Container(),
                    if (value.fasilitasError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        value.fasilitasError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ButtonPrimary(
                      onTap: () {
                        value.cek();
                      },
                      name: "Simpan",
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Users Access",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      value.isLoadingFasilitas
                          ? SizedBox()
                          : ButtonPrimary(
                              onTap: () {
                                value.tambah();
                              },
                              name: "Tambah Users Access",
                            )
                    ],
                  ),
                ),
                Expanded(
                  child: value.isLoading
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProShimmer(height: 10, width: 200),
                              SizedBox(height: 4),
                              ProShimmer(height: 10, width: 120),
                              SizedBox(height: 4),
                              ProShimmer(height: 10, width: 100),
                              SizedBox(height: 4),
                            ],
                          ),
                        )
                      : value.list.isNotEmpty
                          ? RefreshIndicator(
                              onRefresh: () => value.getUsersAccess(),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: SfDataGrid(
                                  frozenRowsCount: 0,
                                  headerRowHeight: 60,
                                  rowHeight: 56,
                                  defaultColumnWidth: 150,
                                  frozenColumnsCount: 2,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility: GridLinesVisibility.both,
                                  selectionMode: SelectionMode.single,
                                  onSelectionChanged: value.onSelectionChanged,
                                  source: DetailDataSource(
                                    value.list.cast<UsersAccessModel>(),
                                  ),
                                  columns: <GridColumn>[
                                    GridColumn(
                                      width: 50,
                                      columnName: 'no',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'kd_bank',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Kode Bank ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'userid',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Users ID ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      width: 300,
                                      columnName: 'namauser',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Nama Users ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'kd_kantor',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Kode Kantor',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      width: 200,
                                      columnName: 'nama_kantor',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Nama Kantor',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      width: 200,
                                      columnName: 'tglexp',
                                      label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Tanggal Kadaluarsa',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    "Users Access Masih Kosong",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailDataSource extends DataGridSource {
  DetailDataSource(List<UsersAccessModel> list) {
    int index = 1;
    _laporanData = list.map<DataGridRow>((data) {
      DataGridRow row = DataGridRow(
        cells: [
          DataGridCell(columnName: 'no', value: index.toString()),
          DataGridCell(columnName: 'bpr_id', value: data.bpr_id),
          DataGridCell(columnName: 'userid', value: data.userid),
          DataGridCell(columnName: 'namauser', value: data.namauser),
          DataGridCell(columnName: 'kdkantor', value: data.kdkantor),
          DataGridCell(
            columnName: 'nama_kantor',
            value: data.namaKantor != null ? data.namaKantor : "",
          ),
          DataGridCell(columnName: 'tglexp', value: data.tglexp),
        ],
      );
      index++;
      return row;
    }).toList();
  }

  List<DataGridRow> _laporanData = [];

  @override
  List<DataGridRow> get rows => _laporanData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'status') {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text((e.value ?? "").toString()),
          );
        }

        if (e.columnName == 'tglexp') {
          String text = "-";
          final raw = (e.value ?? "").toString().trim();
          if (raw.isNotEmpty) {
            try {
              text = DateFormat('dd MMM y').format(DateTime.parse(raw));
            } catch (_) {
              text = raw;
            }
          }

          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            (e.value ?? "").toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  String formatStringData(String data) {
    int numericData = int.tryParse(data) ?? 0;
    final formatter = NumberFormat("#,###");
    return formatter.format(numericData);
  }
}
