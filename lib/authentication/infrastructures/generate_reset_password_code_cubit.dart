import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../domain/authentication_error.dart';
import '../domain/credential.dart';
import 'authentication_repository.dart';

part 'generate_reset_password_code_state.dart';

class GenerateResetPasswordCodeCubit
    extends Cubit<GenerateResetPasswordCodeState> {
  final AuthenticationRepository _authenticationRepository;

  GenerateResetPasswordCodeCubit(this._authenticationRepository)
      : super(GenerateResetPasswordCodeInitial());

  Future<void> generateResetPasswordcode(
      {required Credential credential}) async {
    emit(GenerateResetPasswordCodeLoading());
    final response = await _authenticationRepository.generateResetPasswordCode(
        credential: credential);
    response.fold(
      (sucess) => emit(GenerateResetPasswordCodeLoaded()),
      (faillure) => emit(GenerateResetPasswordCodeError(faillure)),
    );
  }
}
