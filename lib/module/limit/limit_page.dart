import 'package:cms_ibpr/module/limit/limit_harian_page.dart';
import 'package:cms_ibpr/module/limit/limit_notifier.dart';
import 'package:cms_ibpr/module/limit/limit_trx_page.dart';
import 'package:cms_ibpr/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LimitPage extends StatelessWidget {
  const LimitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LimitNotifier(context: context),
      child: Consumer<LimitNotifier>(
        builder: (context, value, child) => SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                // decoration: BoxDecoration(color: colorPrimary),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => value.gantiPage(0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: value.page == 0
                                ? colorPrimary
                                : Colors.grey[200]),
                        child: Text(
                          "Limit Harian",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                value.page == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    InkWell(
                      onTap: () => value.gantiPage(1),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: value.page == 1
                                ? colorPrimary
                                : Colors.grey[200]),
                        child: Text(
                          "Limit Transaksi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                value.page == 1 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              value.page == 0
                  ? Expanded(child: LimitHarianPage())
                  : Expanded(child: LimitTrxPage())
            ],
          ),
        )),
      ),
    );
  }
}
