import 'package:get_it/get_it.dart';

import '../features/contacts/data/datasources/contacts_remote_data_source.dart';
import '../features/contacts/data/repositories/contacts_repository_impl.dart';
import '../features/contacts/domain/repositories/contacts_repository.dart';
import '../features/contacts/domain/usecases/usecases.dart';
import '../features/contacts/presentation/blocs/blocs.dart';
import 'api_client.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton(() => ApiClient());

  // Data sources
  getIt.registerLazySingleton<ContactsRemoteDataSource>(
    () => ContactsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(
      remoteDataSource: getIt<ContactsRemoteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetCitiesUseCase>(
      () => GetCitiesUseCase(repository: getIt<ContactsRepository>()));
  getIt.registerLazySingleton<GetContactsUseCase>(
    () => GetContactsUseCase(repository: getIt<ContactsRepository>()),
  );
  getIt.registerLazySingleton<AddContactUseCase>(
    () => AddContactUseCase(repository: getIt<ContactsRepository>()),
  );

  // Blocs
  getIt.registerFactory<ContactsListBloc>(
    () => ContactsListBloc(
      getContactsUseCase: getIt<GetContactsUseCase>(),
      getCitiesUseCase: getIt<GetCitiesUseCase>(),
    ),
  );

  getIt.registerFactory<AddContactBloc>(
    () => AddContactBloc(addContactUseCase: getIt<AddContactUseCase>()),
  );
}
