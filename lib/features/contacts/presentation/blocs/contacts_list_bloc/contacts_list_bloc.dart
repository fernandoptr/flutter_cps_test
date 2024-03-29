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
  }

  Future<void> _onContactsListFetched(
    ContactsListFetched event,
    Emitter<ContactsListState> emit,
  ) async {
    emit(state.copyWith(status: ContactsListStatus.loading));

    try {
      final contactResult = await _getContactsUseCase();
      _allContacts = switch (contactResult) {
        Success(data: final data) => _sortContactsByName(data, true),
        Failure(exception: final exception) => throw exception,
      };

      final citiesResult = await _getCitiesUseCase();
      final cities = switch (citiesResult) {
        Success(data: final data) => _sortCitiesByName(data),
        Failure(exception: final exception) => throw exception,
      };

      emit(
        state.copyWith(
          status: ContactsListStatus.success,
          contacts: _allContacts,
          cities: cities,
          searchName: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ContactsListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onContactsListSearchTextChanged(
    ContactsListSearchTextChanged event,
    Emitter<ContactsListState> emit,
  ) {
    final searchedContacts = _searchContactsByName(
      _allContacts,
      event.searchName,
    );

    emit(
      state.copyWith(
        contacts: searchedContacts,
        searchName: event.searchName,
      ),
    );
    return;
  }

  List<Contact> _sortContactsByName(List<Contact> contacts, bool isAscending) {
    contacts.sort((a, b) => isAscending
        ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
        : b.name.toLowerCase().compareTo(a.name.toLowerCase()));
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
}
