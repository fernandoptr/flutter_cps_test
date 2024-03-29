import '../../../../core/utils/result.dart';
import '../../../../core/utils/utils.dart';
import '../../../../services/services.dart';
import '../models/dto/dto.dart';

abstract class ContactsRemoteDataSource {
  Future<Result<List<CityDto>, Exception>> getCities();

  Future<Result<List<UserDto>, Exception>> getContacts();

  Future<Result<UserDto, Exception>> addContact(UserDto userDto);
}

class ContactsRemoteDataSourceImpl implements ContactsRemoteDataSource {
  final ApiClient _apiClient;

  const ContactsRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Result<List<CityDto>, Exception>> getCities() async {
    try {
      final result = await _apiClient.getCities();
      return switch (result) {
        Success(data: final data) => Success(
            data.map((e) => CityDto.fromJson(e)).toList(),
          ),
        Failure(exception: final exception) => Failure(exception),
      };
    } catch (e) {
      return Failure(Exception('Failed to get cities: $e'));
    }
  }

  @override
  Future<Result<List<UserDto>, Exception>> getContacts() async {
    try {
      final result = await _apiClient.getUsers();
      return switch (result) {
        Success(data: final data) => Success(
            data.map((e) => UserDto.fromJson(e)).toList(),
          ),
        Failure(exception: final exception) => Failure(exception),
      };
    } catch (e) {
      return Failure(Exception('Failed to get contacts: $e'));
    }
  }

  @override
  Future<Result<UserDto, Exception>> addContact(UserDto userDto) async {
    try {
      final result = await _apiClient.addUser(userDto.toJson());
      return switch (result) {
        Success(data: final data) => Success(UserDto.fromJson(data)),
        Failure(exception: final exception) => Failure(exception),
      };
    } catch (e) {
      return Failure(Exception('Failed to add contact: $e'));
    }
  }
}
