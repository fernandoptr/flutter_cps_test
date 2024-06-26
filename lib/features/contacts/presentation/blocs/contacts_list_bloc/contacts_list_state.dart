part of 'contacts_list_bloc.dart';

enum ContactsListStatus { initial, loading, success, failure }

class ContactsListState extends Equatable {
  final ContactsListStatus status;
  final List<Contact> contacts;
  final List<City> cities;

  final String searchName;
  final bool isSortAscByName;
  final City? filteredCity;

  final String? errorMessage;

  const ContactsListState({
    required this.status,
    required this.contacts,
    required this.cities,
    required this.searchName,
    required this.isSortAscByName,
    required this.filteredCity,
    this.errorMessage,
  });

  const ContactsListState.initial()
      : status = ContactsListStatus.initial,
        contacts = const <Contact>[],
        cities = const <City>[],
        searchName = '',
        isSortAscByName = true,
        filteredCity = null,
        errorMessage = null;

  ContactsListState copyWith({
    ContactsListStatus? status,
    List<Contact>? contacts,
    List<City>? cities,
    String? searchName,
    bool? isSortAscByName,
    City? filteredCity,
    String? errorMessage,
  }) {
    return ContactsListState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      cities: cities ?? this.cities,
      searchName: searchName ?? this.searchName,
      isSortAscByName: isSortAscByName ?? this.isSortAscByName,
      filteredCity: filteredCity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        contacts,
        cities,
        searchName,
        isSortAscByName,
        filteredCity,
        errorMessage,
      ];

  @override
  bool? get stringify => true;
}
