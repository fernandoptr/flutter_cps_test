import 'package:flutter/material.dart';
import '../features/contacts/domain/entities/entities.dart';
import '../features/contacts/presentation/pages/pages.dart';

class RoutePaths {
  static const String home = '/';
  static const String addContact = '/add_contact';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.home:
        return MaterialPageRoute(builder: (_) => const ContactsListPage());
      case RoutePaths.addContact:
        final args = settings.arguments as List<City>?;
        return MaterialPageRoute(
          builder: (_) => AddContactPage(cities: args!),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Unknown route')),
      ),
    );
  }
}

class AddContactArguments {
  final List<City> cities;

  AddContactArguments({required this.cities});
}
