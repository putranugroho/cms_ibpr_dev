import 'package:camera/camera.dart';
import 'package:cms_ibpr/main.dart';
import 'package:cms_ibpr/models/index.dart';
import 'package:cms_ibpr/module/nasabah/nasabah_notifer.dart';
import 'package:cms_ibpr/network/network.dart';
import 'dart:math' as math;

import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:cms_ibpr/utils/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/colors.dart';
import '../../utils/images_path.dart';
import '../../utils/pro_shimmer.dart';

class NasabahPage extends StatelessWidget {
  const NasabahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NasabahNotifier(context: context),
      child: Consumer<NasabahNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            key: value.key,
            endDrawer: Drawer(
              width: 650,
              child: Form(
                key: value.keyForm,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stepper(
                    currentStep: value.currentStep,
                    onStepContinue: value.onStepContinue,
                    onStepCancel: value.onStepCancel,
                    controlsBuilder: (context, detail) => Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      child: value.currentStep == 2
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: value.onStepContinue,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      colorPrimary,
                                    ),
                                  ),
                                  child: const Text(
                                    'Simpan',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: value.onStepCancel,
                                  child: const Text('Cancel'),
                                ),
                                if (value.editData) ...[
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: value.confirm,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.red,
                                      ),
                                    ),
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ]
                              ],
                            )
                          : Row(
                              children: [
                                ElevatedButton(
                                  onPressed: value.onStepContinue,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      colorPrimary,
                                    ),
                                  ),
                                  child: const Text(
                                    'Lanjut',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: value.onStepCancel,
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                    ),
                    steps: [
                      Step(
                        title: const Text("Data Diri"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "No. Rekening",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              enabled: !value.editData,
                              controller: value.norek,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    value.inquery();
                                  },
                                  child: Container(
                                    width: 100,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorPrimary,
                                    ),
                                    child: const Text(
                                      "Tampilkan",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              validator: (e) {
                                final text = (e ?? '').trim();
                                if (text.isEmpty) {
                                  return "No. rekening wajib diisi";
                                }
                                return null;
                              },
                            ),
                            if (value.rekeningError != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                value.rekeningError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Text(
                              "Nama Rekening",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              enabled: false,
                              controller: value.namarek,
                              validator: (e) {
                                final text = (e ?? '').trim();
                                if (text.isEmpty) {
                                  return "Nama rekening wajib ditampilkan";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Nomor Ponsel",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              enabled: !value.editData,
                              controller: value.noHp,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (e) {
                                final text = (e ?? '').trim();
                                if (text.isEmpty) {
                                  return "Nomor ponsel wajib diisi";
                                }
                                if (text.length < 10) {
                                  return "Nomor ponsel minimal 10 digit";
                                }
                                if (text.length > 14) {
                                  return "Nomor ponsel maksimal 14 digit";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No. Identitas",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              enabled: !value.editData,
                              controller: value.nik,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (e) {
                                final text = (e ?? '').trim();
                                if (text.isEmpty) {
                                  return "No. identitas wajib diisi";
                                }
                                if (text.length != 16) {
                                  return "No. identitas harus 16 digit";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Tanggal Lahir",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () => value.gantiTanggal(),
                              child: TextFormField(
                                enabled: false,
                                controller: value.tglLahir,
                                validator: (e) {
                                  final text = (e ?? '').trim();
                                  if (text.isEmpty) {
                                    return "Tanggal lahir wajib diisi";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Jenis Kelamin",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Radio(
                                  activeColor: Colors.blue,
                                  value: "l",
                                  groupValue: value.gender,
                                  onChanged: (e) => value.pilihGender("l"),
                                ),
                                const Text("Laki-laki"),
                                const SizedBox(width: 24),
                                Radio(
                                  activeColor: Colors.blue,
                                  value: "p",
                                  groupValue: value.gender,
                                  onChanged: (e) => value.pilihGender("p"),
                                ),
                                const Text("Perempuan"),
                              ],
                            ),
                            if (value.genderError != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                value.genderError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Text(
                              "Account Type",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton(
                              isExpanded: true,
                              value: value.acctTypeModel,
                              items: value.listAccount
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          e.keterangan,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (e) {
                                value.pilihAcctType(e!);
                              },
                            ),
                            if (value.acctTypeError != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                value.acctTypeError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        isActive: value.currentStep >= 0,
                        state: value.currentStep > 0 ? StepState.complete : StepState.indexed,
                      ),
                      Step(
                        title: const Text("Foto KTP"),
                        content: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "KTP Nasabah",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            if (value.switchFoto == false) ...[
                              SizedBox(
                                width: 400,
                                height: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: value.controller2!.value.isInitialized
                                      ? value.image2 == null
                                          ? Transform.flip(
                                              flipX: true,
                                              child: SizedBox(
                                                width: 400,
                                                height: 220,
                                                child: CameraPreview(
                                                  value.controller2!,
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: Transform.flip(
                                                    flipX: true,
                                                    child: Image.network(
                                                      value.image2!.path,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      value.cancelKTP();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                      : InkWell(
                                          onTap: () => value.openKTP(),
                                          child: Container(
                                            width: 400,
                                            height: 220,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            child: value.editData
                                                ? Transform.flip(
                                                    flipX: true,
                                                    child: Image.network(
                                                      NetworkURL.photoView(
                                                        type: "ktp",
                                                        fileOrPath: value.nasabahModel!.fhoto1,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: 400,
                                                      height: 220,
                                                    ),
                                                  )
                                                : const Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        size: 50,
                                                      ),
                                                      SizedBox(height: 16),
                                                      Text(
                                                        "Klik disini untuk buka kamera",
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              value.tombolcapture == true
                                  ? Ink(
                                      decoration: const ShapeDecoration(
                                        color: colorPrimary,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          value.captureKTP();
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ],
                        ),
                        isActive: value.currentStep >= 1,
                        state: value.currentStep > 1 ? StepState.complete : StepState.indexed,
                      ),
                      Step(
                        title: const Text("Foto Selfie KTP"),
                        content: Column(
                          children: [
                            const Text(
                              "Selfie KTP",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 250,
                              height: 400,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: value.controller!.value.isInitialized
                                    ? value.image == null
                                        ? Transform.flip(
                                            flipX: true,
                                            child: CameraPreview(
                                              value.controller!,
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              Positioned.fill(
                                                child: Transform.flip(
                                                  flipX: true,
                                                  child: Image.network(
                                                    value.image!.path,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    value.cancelSelfi();
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                    : InkWell(
                                        onTap: () => value.openKTPSelfi(),
                                        child: Container(
                                          width: 250,
                                          height: 400,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: value.editData
                                              ? Transform.flip(
                                                  flipX: true,
                                                  child: Image.network(
                                                    NetworkURL.photoView(
                                                      type: "selfie",
                                                      fileOrPath: value.nasabahModel!.fhoto2,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    width: 250,
                                                    height: 400,
                                                  ),
                                                )
                                              : const Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      size: 50,
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      "Klik disini untuk buka kamera",
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            value.tombolcaptureselfie == true
                                ? Ink(
                                    decoration: const ShapeDecoration(
                                      color: colorPrimary,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        value.captureSelfiKTP();
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        isActive: value.currentStep >= 2,
                        state: value.currentStep > 2 ? StepState.complete : StepState.indexed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Nasabah",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ButtonPrimary(
                        onTap: () {
                          value.tambah();
                        },
                        name: "Tambah Nasabah",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => value.getNasabah(),
                    child: ListView(
                      children: [
                        value.isLoading
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
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        child: SfDataGrid(
                                          headerRowHeight: 60,
                                          defaultColumnWidth: 150,
                                          frozenColumnsCount: 2,
                                          shrinkWrapRows: true,
                                          gridLinesVisibility: GridLinesVisibility.both,
                                          headerGridLinesVisibility: GridLinesVisibility.both,
                                          selectionMode: SelectionMode.single,
                                          onSelectionChanged: value.onSelectionChanged,
                                          source: DetailDataSource(
                                            value.list.cast<NsaabahModel>(),
                                          ),
                                          columns: <GridColumn>[
                                            GridColumn(
                                              width: 50,
                                              columnName: 'no',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'nama',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Nama Lengkap ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'no_rek',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'No Rekening ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              width: 300,
                                              columnName: 'nama_rek',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Nama Rekening ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'phone',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Nomor Ponsel',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              width: 200,
                                              columnName: 'nik',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'No. Identitas',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'status',
                                              label: Container(
                                                color: colorPrimary,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Status',
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
                                    ],
                                  )
                                : SizedBox(
                                    height: 300,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageAssets.user,
                                          height: 100,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Nasabah Masih Kosong",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
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
  DetailDataSource(List<NsaabahModel> list) {
    int index = 1;
    _laporanData = list.map<DataGridRow>((data) {
      DataGridRow row = DataGridRow(
        cells: [
          DataGridCell(columnName: 'no', value: index.toString()),
          DataGridCell(columnName: 'nama', value: data.nama),
          DataGridCell(columnName: 'no_rek', value: data.noRek),
          DataGridCell(columnName: 'nama_rek', value: data.namaRek),
          DataGridCell(columnName: 'phone', value: data.noHp),
          DataGridCell(columnName: 'nik', value: data.noKtp),
          DataGridCell(columnName: 'status', value: data.status),
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
