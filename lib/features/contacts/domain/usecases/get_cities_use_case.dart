import '../../../../core/utils/utils.dart';

import '../entities/entities.dart';
import '../repositories/contacts_repository.dart';

class GetCitiesUseCase {
  final ContactsRepository _repository;

  GetCitiesUseCase({required ContactsRepository repository})
      : _repository = repository;

  Future<Result<List<City>, Exception>> call() {
    return _repository.getCities();
  }
}
