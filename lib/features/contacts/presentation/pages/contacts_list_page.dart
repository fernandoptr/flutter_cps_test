import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ContactsListBloc>().add(ContactsListFetched());
        },
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  ContactsListAppBar _buildAppBar() {
    return const ContactsListAppBar();
  }

  BlocBuilder<ContactsListBloc, ContactsListState> _buildBody() {
    return BlocBuilder<ContactsListBloc, ContactsListState>(
      builder: (context, state) {
        return switch (state.status) {
          ContactsListStatus.initial ||
          ContactsListStatus.loading =>
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ContactsListStatus.success => ContactsListScrollView(
              contacts: state.contacts,
            ),
          ContactsListStatus.failure => SliverFillRemaining(
              child: Center(
                child: Text(state.errorMessage),
              ),
            ),
        };
      },
    );
  }
}
