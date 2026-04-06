import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/kantor/kantor_notifier.dart';

import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/colors.dart';
import '../../utils/images_path.dart';
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
          key: value.key,
          endDrawer: Drawer(
            width: 500,
            child: Form(
              key: value.keyForm,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  // const Text(
                  //   "BPR ",
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  // DropdownButton(
                  //     isExpanded: true,
                  //     value: value.sandiBankModel,
                  //     items: value.listSandi
                  //         .map((e) => DropdownMenuItem(
                  //               value: e,
                  //               child: Container(
                  //                 padding:
                  //                     const EdgeInsets.symmetric(vertical: 12),
                  //                 child: Text(
                  //                   e.nama,
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                 ),
                  //               ),
                  //             ))
                  //         .toList(),
                  //     onChanged: (e) {
                  //       value.pilihBank(e!);
                  //     }),
                  // const SizedBox(
                  //   height: 16,
                  // ),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      value.editData ? "Edit Kantor" : "Tambah Kantor",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Kode Kantor ",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    controller: value.kdKantor,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Nama Kantor ",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    controller: value.namakantor,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ButtonPrimary(
                    onTap: () {
                      value.cek();
                    },
                    name: "Simpan",
                  ),
                  value.editData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            ButtonPrimary(
                              onTap: () {
                                value.confirm();
                              },
                              name: "Hapus",
                            ),
                          ],
                        )
                      : SizedBox()
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
                        "Kantor",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ButtonPrimary(
                      onTap: () {
                        value.tambah();
                      },
                      name: "Tambah Kantor",
                    )
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () => value.getKantor(),
                child: ListView(
                  children: [
                    value.isLoading
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProShimmer(height: 10, width: 200),
                                SizedBox(
                                  height: 4,
                                ),
                                ProShimmer(height: 10, width: 120),
                                SizedBox(
                                  height: 4,
                                ),
                                ProShimmer(height: 10, width: 100),
                                SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          )
                        : value.listResult.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: SfDataGrid(
                                      headerRowHeight: 60,
                                      defaultColumnWidth: 150,
                                      // frozenColumnsCount: 2,
                                      // controller: value.dataGridController,
                                      gridLinesVisibility: GridLinesVisibility.both,
                                      headerGridLinesVisibility: GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      onSelectionChanged: value.onSelectionChanged,
                                      source: DetailDataSource(value.list.cast<KantorModel>()),
                                      columns: <GridColumn>[
                                        GridColumn(
                                            width: 50,
                                            columnName: 'no',
                                            label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: Text('No', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
                                        GridColumn(
                                            width: 200,
                                            columnName: 'kd_bank',
                                            label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: Text('Kode Bank ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
                                        GridColumn(
                                            width: 300,
                                            columnName: 'kd_kantor',
                                            label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: Text('Kode Kantor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
                                        GridColumn(
                                            width: 300,
                                            columnName: 'nama_kantor',
                                            label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: Text('Nama Kantor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                  ],
                ),
              ))
            ],
          ),
        )),
      ),
    );
  }
}

class DetailDataSource extends DataGridSource {
  DetailDataSource(List<KantorModel> list) {
    int index = 1;
    _laporanData = list.map<DataGridRow>((data) {
      DataGridRow row = DataGridRow(
        cells: [
          DataGridCell(columnName: 'no', value: index.toString()),
          DataGridCell(columnName: 'kd_bank', value: data.bpr_id),
          DataGridCell(columnName: 'kd_kantor', value: data.kdKantor),
          DataGridCell(columnName: 'nama_kantor', value: data.namaKantor),
          // DataGridCell(columnName: 'days', value: data.day),
          // DataGridCell(columnName: 'start_time', value: data.startTime),
          // DataGridCell(columnName: 'end_time', value: data.endTime),

          // DataGridCell(
          //     columnName: 'status',
          //     value: data.isDeleted == "N" ? "Active" : "Non-active"),
          // DataGridCell(columnName: 'batch', value: data.batch),
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
            decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(8)),
            child: Text(e.value.toString()),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
      }).toList(),
    );
  }

  String formatStringData(String data) {
    int numericData = int.tryParse(data) ?? 0;
    final formatter = NumberFormat("#,###");
    return formatter.format(numericData);
  }
}
