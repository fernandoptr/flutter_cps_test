import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

part 'contacts_list_event.dart';
part 'contacts_list_state.dart';

class ContactsListBloc extends Bloc<ContactsListEvent, ContactsListState> {
  final GetContactsUseCase _getContactsUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  List<Contact> _allContacts = [];

  ContactsListBloc(
      {required GetContactsUseCase getContactsUseCase,
      required GetCitiesUseCase getCitiesUseCase})
      : _getContactsUseCase = getContactsUseCase,
        _getCitiesUseCase = getCitiesUseCase,
        super(const ContactsListState.initial()) {
    on<ContactsListFetched>(_onContactsListFetched);
    on<ContactsListSearchTextChanged>(_onContactsListSearchTextChanged);
    on<ContactsListSortByNameToggled>(_onContactsListSortByNameToggled);
    on<ContactsListCityFilterSelected>(_onContactsListCityFilterSelected);
  }

  Future<void> _onContactsListFetched(
    ContactsListFetched event,
    Emitter<ContactsListState> emit,
  ) async {
    emit(state.copyWith(
      status: ContactsListStatus.loading,
      searchName: '',
      isSortAscByName: true,
      filteredCity: null,
    ));

    try {
      final contactResult = await _getContactsUseCase();
      _allContacts = _processContactsResult(contactResult);

      final citiesResult = await _getCitiesUseCase();
      final cities = _processCitiesResult(citiesResult);

      emit(
        state.copyWith(
          status: ContactsListStatus.success,
          contacts: _allContacts,
          cities: cities,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ContactsListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onContactsListSearchTextChanged(
    ContactsListSearchTextChanged event,
    Emitter<ContactsListState> emit,
  ) {
    final contacts = _updateContacts(
      contacts: _allContacts,
      searchName: event.searchName,
      isAscending: state.isSortAscByName,
      filteredCity: state.filteredCity,
    );

    emit(state.copyWith(
      contacts: contacts,
      searchName: event.searchName,
      filteredCity: state.filteredCity,
    ));
    return;
  }

  void _onContactsListSortByNameToggled(
    ContactsListSortByNameToggled event,
    Emitter<ContactsListState> emit,
  ) {
    final contacts = _updateContacts(
      contacts: state.contacts,
      searchName: state.searchName,
      isAscending: !state.isSortAscByName,
      filteredCity: state.filteredCity,
    );

    emit(state.copyWith(
      contacts: contacts,
      isSortAscByName: !state.isSortAscByName,
      filteredCity: state.filteredCity,
    ));
  }

  void _onContactsListCityFilterSelected(
    ContactsListCityFilterSelected event,
    Emitter<ContactsListState> emit,
  ) {
    final contacts = _updateContacts(
      contacts: _allContacts,
      searchName: state.searchName,
      isAscending: state.isSortAscByName,
      filteredCity: event.city,
    );

    emit(
      state.copyWith(
        contacts: contacts,
        filteredCity: event.city,
      ),
    );
  }

  List<Contact> _processContactsResult(
      Result<List<Contact>, Exception> result) {
    return switch (result) {
      Success(data: final data) => _sortContactsByName(data),
      Failure(exception: final exception) => throw exception,
    };
  }

  List<City> _processCitiesResult(Result<List<City>, Exception> result) {
    return switch (result) {
      Success(data: final data) => _sortCitiesByName(data),
      Failure(exception: final exception) => throw exception,
    };
  }

  List<Contact> _sortContactsByName(
    List<Contact> contacts, {
    bool isAscending = true,
  }) {
    contacts.sort(
      (a, b) => isAscending
          ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
          : b.name.toLowerCase().compareTo(a.name.toLowerCase()),
    );
    return contacts;
  }

  List<City> _sortCitiesByName(List<City> cities) {
    cities.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return cities;
  }

  List<Contact> _searchContactsByName(
      List<Contact> contacts, String searchName) {
    return searchName.isEmpty
        ? contacts
        : contacts
            .where((contact) => contact.name.toLowerCase().contains(
                  searchName.toLowerCase(),
                ))
            .toList();
  }

  List<Contact> _filterContactsByCity(
      List<Contact> contacts, City? selectedCity) {
    return selectedCity == null
        ? contacts
        : contacts
            .where((contact) =>
                contact.city.toLowerCase() == selectedCity.name.toLowerCase())
            .toList();
  }

  List<Contact> _updateContacts({
    required List<Contact> contacts,
    String? searchName,
    required bool isAscending,
    City? filteredCity,
  }) {
    var updatedContacts = _filterContactsByCity(contacts, filteredCity);
    updatedContacts = _searchContactsByName(updatedContacts, searchName ?? '');
    updatedContacts =
        _sortContactsByName(updatedContacts, isAscending: isAscending);

    return updatedContacts;
  }
}
