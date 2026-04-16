import 'package:cms_ibpr/module/mpin/mpin_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MPINPage extends StatelessWidget {
  const MPINPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MPINNotifier(context: context),
      child: Consumer<MPINNotifier>(
        builder: (context, value, child) => SafeArea(
          child: Scaffold(),
        ),
      ),
    );
  }
}
