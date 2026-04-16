import 'package:cms_ibpr/module/journal/setup_journal_transaksi_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class SetupJournalTransaksiPage extends StatelessWidget {
  const SetupJournalTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetupJournalTransaksiNotifier(context: context),
      child: Consumer<SetupJournalTransaksiNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xfff3f3f3),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.centerLeft,
                  color: colorPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "Setup Journal CMS",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: "Arial Black",
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: value.keyForm,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildMasterSection(value),
                        const SizedBox(height: 24),
                        _buildDetailSection(value),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ButtonPrimary(
                              onTap: () {
                                value.submit();
                              },
                              name: "Simpan Setup Jurnal",
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildMasterSection(SetupJournalTransaksiNotifier value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  "Transaksi Code",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Text(
                  "Keterangan",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Text(
                  "Jurnal (Y/N)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12),
              SizedBox(width: 100),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(value.tcodeList.length, (index) {
            final row = value.tcodeList[index];
            final isSelected = value.selectedTcode == row['code'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _readonlyBox(row['code'] ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: _readonlyBox(row['name'] ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _readonlyBox("Y", textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.green : colorPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        value.changeTcode(row['code'] ?? '');
                      },
                      child: Text(isSelected ? "Aktif" : "Tampil"),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDetailSection(SetupJournalTransaksiNotifier value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffafafa),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 140,
                child: Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Text(
                    "Transaksi Code",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: value.selectedTcode ?? '',
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: "TCode",
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: value.ketTcode,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: "Keterangan TCode",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(value.journals.length, (index) {
            final item = value.journals[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          "Jurnal ${index + 1}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "( ${item.keteranganController.text} )",
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // DEBET
                  _journalSideBlock(
                    title: "DEBET",
                    jenisText: item.jenisSbbDebitController.text,
                    sourceController: item.debitSourceController,
                    accountController: item.debitNoRek,
                    nameController: item.debitNamaRek,
                    enabled: !item.useNasabahDebit,
                    onTapTampil: item.useNasabahDebit
                        ? null
                        : () {
                            value.inquiryDebit(index);
                          },
                    accountLabel: "Account Debet",
                  ),

                  const SizedBox(height: 24),

                  // KREDIT
                  _journalSideBlock(
                    title: "KREDIT",
                    jenisText: item.jenisSbbKreditController.text,
                    sourceController: item.kreditSourceController,
                    accountController: item.kreditNoRek,
                    nameController: item.kreditNamaRek,
                    enabled: !item.useNasabahKredit,
                    onTapTampil: item.useNasabahKredit
                        ? null
                        : () {
                            value.inquiryKredit(index);
                          },
                    accountLabel: "Account Kredit",
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _journalSideBlock({
    required String title,
    required String jenisText,
    required TextEditingController sourceController,
    required TextEditingController accountController,
    required TextEditingController nameController,
    required bool enabled,
    required VoidCallback? onTapTampil,
    required String accountLabel,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "( $jenisText )",
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  accountLabel,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    enabled: false,
                    controller: sourceController,
                    decoration: const InputDecoration(
                      labelText: "Sumber Rekening",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: accountController,
                          enabled: enabled,
                          decoration: InputDecoration(
                            labelText: "Nomor Rekening",
                            hintText: enabled ? null : "OFF jika Rek Nasabah",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: enabled ? colorPrimary : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: onTapTampil,
                          child: const Text("Tampil"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Nama Account",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _readonlyBox(String text, {TextAlign textAlign = TextAlign.left}) {
    return Container(
      height: 52,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
