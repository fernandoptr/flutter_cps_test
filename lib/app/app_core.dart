import 'package:flutter/material.dart';

import '../core/themes/themes.dart';
import '../core/utils/utils.dart';
import '../features/contacts/presentation/pages/pages.dart';
import 'app.dart';

class AppCore extends StatelessWidget {
  const AppCore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: RoutePaths.home,
      home: const ContactsListPage(),
    );
  }
}
