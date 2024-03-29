part of 'add_contact_bloc.dart';

enum AddContactStatus { initial, loading, success, failure }

class AddContactState extends Equatable {
  final AddContactStatus status;
  final Contact? submittedContact;
  final String? errorMessage;

  const AddContactState({
    required this.status,
    this.submittedContact,
    this.errorMessage,
  });

  const AddContactState.initial()
      : status = AddContactStatus.initial,
        submittedContact = null,
        errorMessage = null;

  AddContactState copyWith({
    AddContactStatus? status,
    Contact? submittedContact,
    String? errorMessage,
  }) {
    return AddContactState(
      status: status ?? this.status,
      submittedContact: submittedContact ?? this.submittedContact,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, submittedContact, errorMessage];

  @override
  bool? get stringify => true;
}
