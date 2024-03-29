import '../../../../core/utils/utils.dart';
import '../entities/entities.dart';
import '../repositories/contacts_repository.dart';

class AddContactUseCase {
  final ContactsRepository _repository;

  AddContactUseCase({required ContactsRepository repository})
      : _repository = repository;

  Future<Result<Contact, Exception>> call(Contact contact) {
    return _repository.addContact(contact);
  }
}
