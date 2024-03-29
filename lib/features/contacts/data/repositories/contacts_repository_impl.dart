import '../../../../core/utils/result.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_remote_data_source.dart';
import '../models/dto/dto.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDataSource _remoteDataSource;

  const ContactsRepositoryImpl({
    required ContactsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<City>, Exception>> getCities() async {
    try {
      final result = await _remoteDataSource.getCities();
      return switch (result) {
        Success(data: final data) => Success(
            data.map((e) => City(id: e.id, name: e.name)).toList(),
          ),
        Failure(exception: final exception) => Failure(exception),
      };
    } catch (e) {
      return Failure(Exception('Failed to get cities: $e'));
    }
  }

  @override
  Future<Result<List<Contact>, Exception>> getContacts() async {
    try {
      final result = await _remoteDataSource.getContacts();
      return switch (result) {
        Success(data: final data) => Success(
            data
                .map((e) => Contact(
                      id: e.id,
                      name: e.name,
                      email: e.email,
                      phoneNumber: e.phoneNumber,
                      city: e.city,
                      address: e.address,
                    ))
                .toList(),
          ),
        Failure(exception: final exception) => Failure(exception),
      };
    } catch (e) {
      return Failure(Exception('Failed to get contacts: $e'));
    }
  }

  @override
  Future<Result<Contact, Exception>> addContact(Contact contact) async {
    try {
      final result = await _remoteDataSource.addContact(
        UserDto(
          id: contact.id,
          name: contact.name,
          email: contact.email,
          phoneNumber: contact.phoneNumber,
          city: contact.city,
          address: contact.address,
        ),
      );
      return switch (result) {
        Success(data: final data) => Success(
            Contact(
              id: data.id,
              name: data.name,
              email: data.email,
              phoneNumber: data.phoneNumber,
              city: data.city,
              address: data.address,
            ),
          ),
        Failure(exception: final exception) => Failure(exception),
      };
    } catch (e) {
      return Failure(Exception('Failed to add contact: $e'));
    }
  }
}
