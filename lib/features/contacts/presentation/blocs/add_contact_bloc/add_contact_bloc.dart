import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

part 'add_contact_event.dart';
part 'add_contact_state.dart';

class AddContactBloc extends Bloc<AddContactEvent, AddContactState> {
  final AddContactUseCase _addContactUseCase;

  AddContactBloc({
    required AddContactUseCase addContactUseCase,
  })  : _addContactUseCase = addContactUseCase,
        super(const AddContactState.initial()) {
    on<AddContactSubmitted>(_onAddContactSubmitted);
  }

  Future<void> _onAddContactSubmitted(
    AddContactSubmitted event,
    Emitter<AddContactState> emit,
  ) async {
    emit(state.copyWith(status: AddContactStatus.loading));

    try {
      final result = await _addContactUseCase(
        Contact(
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
          city: event.city,
          address: event.address,
        ),
      );
      final contact = switch (result) {
        Success(data: final data) => data,
        Failure(exception: final exception) => throw exception,
      };
      emit(state.copyWith(
        status: AddContactStatus.success,
        submittedContact: contact,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddContactStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
