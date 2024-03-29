import '../../../../core/utils/utils.dart';

import '../entities/entities.dart';
import '../repositories/contacts_repository.dart';

class GetContactsUseCase {
  final ContactsRepository _repository;

  GetContactsUseCase({required ContactsRepository repository})
      : _repository = repository;

  Future<Result<List<Contact>, Exception>> call() {
    return _repository.getContacts();
  }
}
