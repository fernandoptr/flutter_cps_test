import '../../../domain/entities/entities.dart';

class UserDto extends Contact {
  const UserDto({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.city,
    required super.address,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      city: json['city'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'address': address,
    };
  }
}
