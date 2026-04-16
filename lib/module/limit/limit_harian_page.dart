import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/limit/limit_harian_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:cms_ibpr/utils/currency_formatted.dart';
import 'package:cms_ibpr/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/colors.dart';
import '../../utils/pro_shimmer.dart';

class LimitHarianPage extends StatelessWidget {
  const LimitHarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LimitHarianNotifier(context: context),
      child: Consumer<LimitHarianNotifier>(
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
                      "Keterangan",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.desc,
                      enabled: false,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Tarik Tunai", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.trkTunai,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Setor Tunai", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.setorTunai,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Transfer", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.transfer,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("PPOB", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.ppob,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("QRIS", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: value.qr,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        }
                        return null;
                      },
                    ),
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
                      : Padding(
                          padding: EdgeInsets.all(20),
                          child: SfDataGrid(
                            headerRowHeight: 60,
                            rowHeight: 56,
                            defaultColumnWidth: 150,
                            frozenColumnsCount: 3,
                            shrinkWrapRows: false,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            onSelectionChanged: value.onSelectionChanged,
                            source: DetailDataSource(
                              value.list.cast<LimitHarianModel>(),
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
                                columnName: 'kd_acc',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Kode Account ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                width: 200,
                                columnName: 'keterangan',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'tarik_tunai',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Tarik Tunai',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'setor_tunai',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Setor Tunai',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'transfer',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Transfer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ppob',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'PPOB',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'qr',
                                label: Container(
                                  color: colorPrimary,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'QRIS',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailDataSource extends DataGridSource {
  DetailDataSource(List<LimitHarianModel> list) {
    int index = 1;
    _laporanData = list.map<DataGridRow>((data) {
      final row = DataGridRow(
        cells: [
          DataGridCell(columnName: 'no', value: index.toString()),
          DataGridCell(columnName: 'kd_acc', value: (data.acctType ?? "").toString()),
          DataGridCell(columnName: 'keterangan', value: (data.description ?? "").toString()),
          DataGridCell(columnName: 'tarik_tunai', value: (data.trkTunaiHarian ?? "0").toString()),
          DataGridCell(columnName: 'setor_tunai', value: (data.setorHarian ?? "0").toString()),
          DataGridCell(columnName: 'transfer', value: (data.trfHarian ?? "0").toString()),
          DataGridCell(columnName: 'ppob', value: (data.ppobHarian ?? "0").toString()),
          DataGridCell(columnName: 'qr', value: (data.qrHarian ?? "0").toString()),
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
        if (e.columnName != 'no' && e.columnName != 'kd_acc' && e.columnName != 'keterangan') {
          final number = int.tryParse((e.value ?? '0').toString()) ?? 0;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              FormatCurrency.oCcy.format(number),
              textAlign: TextAlign.end,
            ),
          );
        }

        return Container(
          alignment: Alignment.center,
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
