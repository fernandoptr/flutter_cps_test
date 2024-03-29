import '../../../../core/utils/utils.dart';
import '../entities/entities.dart';

abstract class ContactsRepository {
  Future<Result<List<City>, Exception>> getCities();

  Future<Result<List<Contact>, Exception>> getContacts();

  Future<void> addContact(Contact contact);
}
