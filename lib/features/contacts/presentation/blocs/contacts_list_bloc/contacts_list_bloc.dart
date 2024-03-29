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
    on<ContactsListSearchTextChanged>(_onContactsListUpdated);
    on<ContactsListSortByNameToggled>(_onContactsListUpdated);
    on<ContactsListCityFilterSelected>(_onContactsListUpdated);
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
      final contactsResult = await _getContactsUseCase();
      _allContacts = _processContactsResult(contactsResult);

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

  List<Contact> _processContactsResult(
      Result<List<Contact>, Exception> result) {
    return switch (result) {
      Success(data: final data) => _sortContactsByName(data, true),
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
    List<Contact> contacts,
    bool isAscending,
  ) {
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

  void _onContactsListUpdated(
    ContactsListEvent event,
    Emitter<ContactsListState> emit,
  ) {
    final City? filteredCity = event is ContactsListCityFilterSelected
        ? event.city
        : state.filteredCity;
    final String searchName = event is ContactsListSearchTextChanged
        ? event.searchName
        : state.searchName;
    final bool isSortAscByName = event is ContactsListSortByNameToggled
        ? !state.isSortAscByName
        : state.isSortAscByName;
    var updatedContacts = _allContacts;

    updatedContacts = _filterContactsByCity(updatedContacts, filteredCity);
    updatedContacts = _searchContactsByName(updatedContacts, searchName);
    updatedContacts = _sortContactsByName(updatedContacts, isSortAscByName);

    emit(state.copyWith(
      contacts: updatedContacts,
      searchName: searchName,
      isSortAscByName: isSortAscByName,
      filteredCity: filteredCity,
    ));
  }
}
