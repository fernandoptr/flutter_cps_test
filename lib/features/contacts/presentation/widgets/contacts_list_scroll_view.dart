import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class ContactsListScrollView extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsListScrollView({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text('${contact.phoneNumber} • ${contact.city}'),
            leading: CircleAvatar(
              child: Text(contact.name[0].toUpperCase()),
            ),
          );
        },
        childCount: contacts.length,
      ),
    );
  }
}
