import 'package:flutter/material.dart';
import '../core/themes/themes.dart';
import '../core/utils/utils.dart';

class AppCore extends StatelessWidget {
  const AppCore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.light,
      home: const Scaffold(),
    );
  }
}