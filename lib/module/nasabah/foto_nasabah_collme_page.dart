import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/nasabah/foto_nasabah_collme_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/pro_shimmer.dart';

class FotoNasabahCollmePage extends StatelessWidget {
  const FotoNasabahCollmePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FotoNasabahCollmeNotifier(context: context),
      child: Consumer<FotoNasabahCollmeNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          key: value.key,
          endDrawer: Drawer(
            width: 500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: value.fotoNasabahCollmeModel != null
                ? ListView(
                    padding: EdgeInsets.all(32),
                    children: [
                      Text(
                        "Summary Information Update Nasabah",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "KTP",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 400,
                            height: 220,
                            child: Transform.flip(
                              flipX: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "$photo/${value.fotoNasabahCollmeModel!.ktp}",
                                  fit: BoxFit.cover,
                                  width: 400,
                                  height: 220,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Selfi KTP",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 250,
                              height: 400,
                              child: Transform.flip(
                                flipX: true,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "$photo/${value.fotoNasabahCollmeModel!.selfiKtp}",
                                    fit: BoxFit.cover,
                                    width: 250,
                                    height: 400,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      value.fotoNasabahCollmeModel!.status == "PENDING"
                          ? Row(
                              children: [
                                Expanded(
                                  child: ButtonPrimary(
                                    onTap: () {
                                      value.terima();
                                    },
                                    name: "Terima",
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: ButtonSecondary(
                                    onTap: () {
                                      value.tolak();
                                    },
                                    name: "Tolak",
                                  ),
                                ),
                              ],
                            )
                          : SizedBox()
                    ],
                  )
                : ListView(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                alignment: Alignment.centerLeft,
                color: colorPrimary,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Update Foto lewat Web",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: "Arial Black",
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              value.isLoading
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProShimmer(height: 10, width: 200),
                          const SizedBox(
                            height: 4,
                          ),
                          ProShimmer(height: 10, width: 120),
                          const SizedBox(
                            height: 4,
                          ),
                          ProShimmer(height: 10, width: 100),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: value.list.isNotEmpty
                                ? MediaQuery.of(context).size.height - 110
                                : 60,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SfDataGrid(
                              headerRowHeight: 60,
                              defaultColumnWidth: 150,
                              frozenColumnsCount: 3,
                              loadMoreViewBuilder: (BuildContext context,
                                  LoadMoreRows loadMoreRows) {
                                Future<String> loadRows() async {
                                  // Call the loadMoreRows function to call the
                                  // DataGridSource.handleLoadMoreRows method. So, additional
                                  // rows can be added from handleLoadMoreRows method.
                                  await loadMoreRows();
                                  return Future<String>.value('Completed');
                                }

                                return FutureBuilder<String>(
                                    initialData: 'loading',
                                    future: loadRows(),
                                    builder: (context, snapShot) {
                                      if (snapShot.data == 'loading') {
                                        return Container(
                                            height: 60.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: BorderDirectional(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.26)))),
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.deepPurple)));
                                      } else {
                                        return SizedBox.fromSize(
                                            size: Size.zero);
                                      }
                                    });
                              },

                              // controller: value.dataGridController,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              // onSelectionChanged: value.onSelectionChanged,
                              source: DetailDataSource(value),
                              columns: <GridColumn>[
                                GridColumn(
                                    width: 50,
                                    columnName: 'no',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('No',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    columnName: 'tgl_created',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('Tanggal Publish',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    width: 200,
                                    columnName: 'no_rek',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('No Rek',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    columnName: 'nama',
                                    width: 300,
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('nama',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    width: 300,
                                    columnName: 'phone',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('Nomor Ponsel',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    width: 400,
                                    columnName: 'alasan',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('Alasan Penolakan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    columnName: 'status',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('Status',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                                GridColumn(
                                    columnName: 'aksi',
                                    label: Container(
                                        color: colorPrimary,
                                        alignment: Alignment.center,
                                        child: Text('Aksi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )))),
                              ],
                            ),
                          ),
                          value.list.isEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Text(
                                    "Foto update identitas nasabah belum ada data",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }
}

class DetailDataSource extends DataGridSource {
  DetailDataSource(FotoNasabahCollmeNotifier value) {
    studentsNotifier = value;
    buildRowData(value.list);
  }

  FotoNasabahCollmeNotifier? studentsNotifier;

  List<DataGridRow> _laporanData = [];
  @override
  List<DataGridRow> get rows => _laporanData;
  void buildRowData(List<FotoNasabahCollmeModel> list) {
    int index = 1;
    _laporanData = list
        .map<DataGridRow>((data) => DataGridRow(
              cells: [
                DataGridCell(columnName: 'no', value: (index++).toString()),
                DataGridCell(
                    columnName: 'tgl_created', value: data.createdDate),
                DataGridCell(columnName: 'no_rek', value: data.noRek),
                DataGridCell(columnName: 'nama', value: data.namaNasabah),
                DataGridCell(columnName: 'phone', value: data.phone),
                DataGridCell(columnName: 'alasan', value: data.reasonRejected),

                DataGridCell(columnName: 'status', value: data.status),
                DataGridCell(columnName: 'aksi', value: data.id),
                // DataGridCell(columnName: 'batch', value: data.batch),
              ],
            ))
        .toList();
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(seconds: 2));
    studentsNotifier!.getMore();
    buildRowData(studentsNotifier!.list);
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'aksi') {
          return InkWell(
            onTap: () {
              studentsNotifier!.edit(e.value);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: colorPrimary, borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Aksi",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
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
