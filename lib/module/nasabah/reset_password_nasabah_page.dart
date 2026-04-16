import 'package:cms_ibpr/module/nasabah/reset_password_nasabah_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class ResetPasswordNasabahPage extends StatelessWidget {
  const ResetPasswordNasabahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordNasabahNotifier(context: context),
      child: Consumer<ResetPasswordNasabahNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.centerLeft,
                  color: colorPrimary,
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Reset Password Nasabah",
                    style: TextStyle(
                      fontSize: 32,
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
                        const Text(
                          "User ID ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: value.userId,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                value.cek();
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
                            if (e == null || e.isEmpty) {
                              return "Please fill this field";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Nama Lengkap ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: value.namaLengkap,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "No Identitas ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: value.noKtp,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Nomor Rekening ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: value.noRekening,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Nomor Ponsel ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: value.nomorPonsel,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            ButtonPrimary(
                              onTap: () {
                                value.generated();
                              },
                              // onTap: value.canSubmit
                              //     ? () {
                              //         value.generated();
                              //       }
                              //     : null,
                              name: "Reset Password",
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
}
