import 'package:flutter/material.dart';

import '../core/themes/themes.dart';
import '../core/utils/utils.dart';
import '../features/contacts/presentation/pages/pages.dart';

class AppCore extends StatelessWidget {
  const AppCore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.light,
      home: const ContactsListPage(),
    );
  }
}
