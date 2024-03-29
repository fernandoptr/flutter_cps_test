import '../entities/entities.dart';
import '../repositories/contacts_repository.dart';

class AddContactUseCase {
  final ContactsRepository _repository;

  AddContactUseCase({required ContactsRepository repository})
      : _repository = repository;

  Future<void> call(Contact contact) async {
    await _repository.addContact(contact);
  }
}
