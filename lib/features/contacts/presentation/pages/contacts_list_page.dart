import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../services/services.dart';
import '../../../../shared/widgets/initials_avatar.dart';
import '../../domain/entities/entities.dart';
import '../blocs/blocs.dart';
import '../blocs/contacts_list_bloc/contacts_list_bloc.dart';
import '../widgets/widgets.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ContactsListBloc>()..add(ContactsListFetched()),
      child: const ContactsListView(),
    );
  }
}

class ContactsListView extends StatelessWidget {
  const ContactsListView({super.key});

  void _onAddContactPressed(BuildContext context) {
    final cities = context.read<ContactsListBloc>().state.cities;
    Navigator.of(context)
        .pushNamed(RoutePaths.addContact, arguments: cities)
        .then(
          (value) =>
              context.read<ContactsListBloc>().add(ContactsListFetched()),
        );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          searchController.clear();
          context.read<ContactsListBloc>().add(ContactsListFetched());
        },
        child: CustomScrollView(
          slivers: [
            _ContactsListAppBar(searchController: searchController),
            _buildBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddContactPressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  BlocBuilder<ContactsListBloc, ContactsListState> _buildBody() {
    return BlocBuilder<ContactsListBloc, ContactsListState>(
      builder: (context, state) {
        return switch (state.status) {
          (ContactsListStatus.initial || ContactsListStatus.loading) =>
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          (ContactsListStatus.success) => _ContactsListScrollView(
              contacts: state.contacts,
            ),
          (ContactsListStatus.failure) => SliverFillRemaining(
              child: Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              ),
            ),
        };
      },
    );
  }
}

class _ContactsListAppBar extends StatelessWidget {
  final TextEditingController searchController;

  const _ContactsListAppBar({required this.searchController});

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
          builder: (context, state) => SortByNameToggler(
            isSortAscByName: state.isSortAscByName,
            onSortByNameToggled: () => context
                .read<ContactsListBloc>()
                .add(ContactsListSortByNameToggled()),
          ),
        ),
        BlocBuilder<ContactsListBloc, ContactsListState>(
          builder: (context, state) => CityFilterPopupMenuButton(
            cityName: state.filteredCity?.name,
            cities: state.cities,
            onCitySelected: (city) {
              context
                  .read<ContactsListBloc>()
                  .add(ContactsListCityFilterSelected(city));
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: CupertinoSearchTextField(
            controller: searchController,
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

class _ContactsListScrollView extends StatelessWidget {
  final List<Contact> contacts;

  const _ContactsListScrollView({required this.contacts});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final contact = contacts[index];

          return ListTile(
              title: Text(contact.name),
              subtitle: Text('${contact.phoneNumber} • ${contact.city}'),
              leading: InitialsAvatar(initial: contact.name),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  builder: (_) {
                    return ContactDetailSheet(contact: contact);
                  },
                );
              });
        },
        childCount: contacts.length,
      ),
    );
  }
}
