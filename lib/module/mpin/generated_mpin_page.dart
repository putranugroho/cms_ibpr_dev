import 'package:cms_ibpr/module/mpin/generated_mpin_notifier.dart';
import 'package:cms_ibpr/utils/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class GeneratedMPINPage extends StatelessWidget {
  const GeneratedMPINPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GeneratedMPINNotifier(context: context),
      child: Consumer<GeneratedMPINNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                alignment: Alignment.centerLeft,
                color: colorPrimary,
                padding: EdgeInsets.all(20),
                child: Text(
                  "Generated MPIN",
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
                  padding: EdgeInsets.all(20),
                  children: [
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
                      controller: value.noHp,
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                        onTap: () {
                          value.cek();
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorPrimary),
                          child: Text(
                            "Tampilkan",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
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
                      "Nama Nasabah ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      enabled: false,
                      controller: value.namaRek,
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
                      controller: value.noRek,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Tanggal Lahir ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      enabled: false,
                      controller: value.tglLahir,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Jenis Kelamin ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "l",
                            groupValue: value.gender,
                            onChanged: (e) {
                              value.gantiGender("l");
                            }),
                        Text("Laki-laki"),
                        SizedBox(
                          width: 32,
                        ),
                        Radio(
                            value: "p",
                            groupValue: value.gender,
                            onChanged: (e) {
                              value.gantiGender("p");
                            }),
                        Text("Perempuan"),
                        SizedBox(
                          width: 32,
                        ),
                      ],
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
                          name: "Generated Sekarang",
                        )
                      ],
                    )
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
