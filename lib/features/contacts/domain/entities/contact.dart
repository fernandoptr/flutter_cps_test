import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String city;
  final String address;

  const Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.address,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        city,
        address,
      ];

  @override
  bool? get stringify => true;
}
