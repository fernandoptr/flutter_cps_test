part of 'contacts_list_bloc.dart';

sealed class ContactsListEvent extends Equatable {
  const ContactsListEvent();

  @override
  List<Object> get props => [];
}

class ContactsListFetched extends ContactsListEvent {}

class ContactsListSearchTextChanged extends ContactsListEvent {
  final String searchName;

  const ContactsListSearchTextChanged(this.searchName);

  @override
  List<Object> get props => [searchName];
}
