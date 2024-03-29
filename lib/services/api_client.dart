import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/utils/utils.dart';

class ApiClient {
  static const String _baseUrl =
      'https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate';
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Result<List<Map<String, dynamic>>, Exception>> getCities() async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/city'));

      if (response.statusCode != 200) {
        throw http.ClientException(
          'Failed to get cities: ${response.statusCode}',
        );
      }
      final data = List<Map<String, dynamic>>.from(
        json.decode(response.body),
      );
      return Success(data);
    } on FormatException catch (e) {
      return Failure(Exception('Failed to parse response $e'));
    } catch (e) {
      return Failure(
        Exception('Failed to perform getCities method: $e'),
      );
    }
  }

  Future<Result<List<Map<String, dynamic>>, Exception>> getUsers() async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/user'));

      if (response.statusCode != 200) {
        throw http.ClientException(
          'Failed to get users: ${response.statusCode}',
        );
      }

      final data = List<Map<String, dynamic>>.from(
        json.decode(response.body),
      );
      return Success(data);
    } on FormatException catch (e) {
      return Failure(Exception('Failed to parse response $e'));
    } catch (e) {
      return Failure(
        Exception('Failed to perform getUsers method: $e'),
      );
    }
  }

  Future<Result<Map<String, dynamic>, Exception>> addUser(
      Map<String, dynamic> userData) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode != 201) {
        throw http.ClientException(
          'Failed to add user: ${response.statusCode}',
        );
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      return Success(data);
    } on FormatException catch (e) {
      return Failure(Exception('Failed to parse response $e'));
    } catch (e) {
      return Failure(
        Exception('Failed to perform addUser method: $e'),
      );
    }
  }
}
