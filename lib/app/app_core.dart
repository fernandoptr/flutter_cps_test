import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/contacts/presentation/pages/pages.dart';
import '../features/contacts/presentation/blocs/blocs.dart';
import '../services/services.dart';

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
      home: BlocProvider(
        create: (context) =>
            getIt<ContactsListBloc>()..add(ContactsListFetched()),
        child: const ContactsListPage(),
      ),
    );
  }
}
