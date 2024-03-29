part of 'add_contact_bloc.dart';

sealed class AddContactEvent extends Equatable {
  const AddContactEvent();

  @override
  List<Object> get props => [];
}

class AddContactSubmitted extends AddContactEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String city;
  final String address;

  const AddContactSubmitted({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.address,
  });

  @override
  List<Object> get props => [name, email, phoneNumber, city, address];
}
