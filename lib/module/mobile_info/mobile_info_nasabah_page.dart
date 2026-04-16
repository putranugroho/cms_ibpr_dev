import 'package:cms_ibpr/module/mobile_info/mobile_info_nasabah_notifer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UsersInfoPage extends StatelessWidget {
  const UsersInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    InputDecoration fieldStyle(String hint) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffece8f0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => UsersInfoNotifier(context: context),
      child: Consumer<UsersInfoNotifier>(
        builder: (context, v, _) => Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("Users Info",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700)),
                          Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xff0f6b83,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                            ),
                            onPressed: v.tambahData,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Tambah Mobile Info",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// SEARCH
                      SizedBox(
                        width: 320,
                        child: TextField(
                          controller: v.cariCtrl,
                          onSubmitted: (_) => v.cariSekarang(),
                          decoration: InputDecoration(
                            hintText: "Cari nama / phone / CIF",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// TABLE
                      Expanded(
                        child: v.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SfDataGrid(
                                source: v.dataSource,
                                columns: v.columns,
                                columnWidthMode: ColumnWidthMode.fill,
                                headerRowHeight: 46,
                                rowHeight: 46,
                              ),
                      ),

                      /// PAGINATION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: v.page > 1 ? v.prevPage : null,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Text("Page ${v.page} / ${v.totalPages}"),
                          IconButton(
                            onPressed:
                                v.page < v.totalPages ? v.nextPage : null,
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: v.tambah
                    ? Container(color: Colors.black.withOpacity(.5))
                    : const SizedBox(),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: v.tambah
                      ? Container(
                          width: 800,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FocusTraversalGroup(
                            child: Form(
                              key: v.keyForm,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffeef4f7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.apartment_outlined,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Tambah Nasabah Mobile Info",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    "Rekening",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: v.rekening,
                                    validator: (e) =>
                                        e!.isEmpty ? "Wajib diisi" : null,
                                    decoration: fieldStyle("Masukkan Rekening")
                                        .copyWith(
                                      suffixIcon: IconButton(
                                        tooltip: "Cari Rekening",
                                        icon: v.isInquiry
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              )
                                            : const Icon(Icons.search),
                                        onPressed: v.isInquiry
                                            ? null
                                            : () => v.inquiryRekening(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    "Nomor CIF",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: v.cif,
                                    readOnly: true,
                                    validator: (e) =>
                                        e!.isEmpty ? "Wajib diisi" : null,
                                    decoration: fieldStyle("CIF"),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    "Nama",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: v.nama,
                                    readOnly: true,
                                    validator: (e) =>
                                        e!.isEmpty ? "Wajib diisi" : null,
                                    decoration: fieldStyle("Nama"),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    "No. Identitas",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: v.noidentitas,
                                    validator: (e) =>
                                        e!.isEmpty ? "Wajib diisi" : null,
                                    decoration:
                                        fieldStyle("Masukkan No Identitas"),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    "Nomor HP",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: v.phone,
                                    validator: (e) =>
                                        e!.isEmpty ? "Wajib diisi" : null,
                                    decoration: fieldStyle("Masukkan No HP"),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    "Tanggal Lahir",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  InkWell(
                                    onTap: v.gantitglkontrak,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: v.tglLahir,
                                      validator: (e) =>
                                          e!.isEmpty ? "Wajib diisi" : null,
                                      decoration:
                                          fieldStyle("Masukkan Tanggal Lahir"),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: v.tutup,
                                        child: const Text("Cancel"),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xff1e6f8b,
                                          ),
                                        ),
                                        onPressed: v.cek,
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
