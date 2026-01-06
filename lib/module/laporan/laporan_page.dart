import 'package:cms_ibpr/module/laporan/laporan_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LaporanNotifier(context: context),
      child: Consumer<LaporanNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Column(
            children: [],
          ),
        )),
      ),
    );
  }
}
