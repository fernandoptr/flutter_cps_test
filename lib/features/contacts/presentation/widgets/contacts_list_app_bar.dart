import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';

class ContactsListAppBar extends StatelessWidget {
  final void Function(String) searchTextChanged;

  const ContactsListAppBar({
    super.key,
    required this.searchTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      title: const Text('Contacts'),
      titleTextStyle: context.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      pinned: true,
      stretch: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: CupertinoSearchTextField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            placeholder: 'Search contacts',
            onChanged: searchTextChanged,
          ),
        ),
      ),
    );
  }
}
