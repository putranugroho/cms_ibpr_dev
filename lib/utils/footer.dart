import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class FooterPage extends StatelessWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    return Container(
      height: 60,
      color: Colors.white,
      child: Center(
        child: Text(
          "Collector Information System @$currentYear",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
