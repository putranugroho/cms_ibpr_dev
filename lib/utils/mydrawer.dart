import 'package:camera/camera.dart';
import 'package:cms_ibpr/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  final value;

  const MyDrawer({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 650,
      child: Form(
        key: value.keyForm,
        child: Stepper(
          currentStep: value.currentStep,
          onStepContinue: value.onStepContinue,
          onStepCancel: value.onStepCancel,
          steps: [
            Step(
              title: const Text("Data Diri"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kantor",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  DropdownButton(
                    isExpanded: true,
                    value: value.kantorModel,
                    items: value.listKantor
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  "(${e.kdBank} - ${e.kdKantor}), ${e.namaKantor}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (e) {
                      value.pilihKantor(e!);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Nama Lengkap",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: !value.editData,
                    controller: value.namaLengkap,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
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
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
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
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No. Rekening",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    enabled: !value.editData,
                    controller: value.norek,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          value.inquery();
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue,
                          ),
                          child: Text(
                            "Tampilkan",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
                    },
                  ),
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
                      if (e!.isEmpty) {
                        return "Please fill this field";
                      } else {
                        return null;
                      }
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
                        if (e!.isEmpty) {
                          return "Please fill this field";
                        } else {
                          return null;
                        }
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
                      Text("Laki-laki"),
                      SizedBox(width: 24),
                      Radio(
                        activeColor: Colors.blue,
                        value: "p",
                        groupValue: value.gender,
                        onChanged: (e) => value.pilihGender("p"),
                      ),
                      Text("Perempuan"),
                    ],
                  ),
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
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  e.keterangan,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (e) {
                      value.pilihAcctType(e!);
                    },
                  ),
                ],
              ),
              isActive: value.currentStep >= 0,
              state: value.currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text("Foto KTP"),
              content: Column(
                children: [
                  Text(
                    "KTP Nasabah",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 300,
                    height: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: value.controller2!.value.isInitialized
                          ? value.image2 == null
                              ? Stack(
                                  children: [
                                    Transform.flip(
                                      flipX: true,
                                      child: Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: CameraPreview(value.controller2!)),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      right: 16,
                                      child: InkWell(
                                        onTap: () {
                                          value.captureKTP();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Transform.flip(
                                  flipX: true,
                                  child: Image.network(
                                    value.image2!.path,
                                    fit: BoxFit.cover,
                                  ),
                                )
                          : InkWell(
                              onTap: () => value.openKTP(),
                              child: Container(
                                width: 300,
                                height: 180,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(width: 1, color: Colors.grey),
                                ),
                                child: value.editData
                                    ? Transform.flip(
                                        flipX: true,
                                        child: Image.network(
                                          "$photo/${value.nasabahModel!.fhoto1}",
                                          fit: BoxFit.cover,
                                          width: 300,
                                          height: 180,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                          ),
                                          SizedBox(height: 16),
                                          Text("Klik disini untuk buka kamera"),
                                        ],
                                      ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              isActive: value.currentStep >= 1,
              state: value.currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text("Foto Selfie KTP"),
              content: Column(
                children: [
                  Text(
                    "Selfie KTP",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 250,
                    height: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: value.controller!.value.isInitialized
                          ? value.image == null
                              ? Stack(
                                  children: [
                                    Transform.flip(
                                      flipX: true,
                                      child: Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: CameraPreview(value.controller!)),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      right: 16,
                                      child: InkWell(
                                        onTap: () {
                                          value.captureSelfieKTP();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Image.network(
                                  value.image!.path,
                                  fit: BoxFit.cover,
                                )
                          : InkWell(
                              onTap: () => value.openKTPSelfie(),
                              child: Container(
                                width: 250,
                                height: 400,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(width: 1, color: Colors.grey),
                                ),
                                child: value.editData
                                    ? Image.network(
                                        "$photo/${value.nasabahModel!.fhoto2}",
                                        fit: BoxFit.cover,
                                        width: 250,
                                        height: 400,
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                          ),
                                          SizedBox(height: 16),
                                          Text("Klik disini untuk buka kamera"),
                                        ],
                                      ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              isActive: value.currentStep >= 2,
              state: value.currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}
