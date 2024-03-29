import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import 'widgets.dart';

import '../../../../core/extensions/extensions.dart';

class ContactsListAppBar extends StatelessWidget {
  const ContactsListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      title: const Text('Contacts'),
      titleTextStyle: context.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      pinned: true,
      stretch: true,
      actions: [
        BlocBuilder<ContactsListBloc, ContactsListState>(
          builder: (context, state) {
            return SortByNameToggler(
                isSortAscByName: state.isSortAscByName,
                onSortByNameToggled: () => context
                    .read<ContactsListBloc>()
                    .add(ContactsListSortByNameToggled()));
          },
        )
      ],
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
            onChanged: (value) => context
                .read<ContactsListBloc>()
                .add(ContactsListSearchTextChanged(value)),
          ),
        ),
      ),
    );
  }
}
