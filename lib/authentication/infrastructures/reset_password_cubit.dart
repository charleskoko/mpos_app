import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/authentication/domain/authentication_error.dart';
import 'package:mpos_app/authentication/domain/credential.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_repository.dart';

import '../domain/reset_password_data.dart';
part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthenticationRepository _authenticationRepository;

  ResetPasswordCubit(this._authenticationRepository)
      : super(ResetPasswordInitial());

  Future<void> resetPassword(
      {required ResetPasswordData resetPasswordData}) async {
    emit(ResetPasswordLoading());
    final response = await _authenticationRepository.resetPassword(
        resetPassword: resetPasswordData);
    response.fold(
      (sucess) => emit(ResetPasswordLoaded()),
      (faillure) => emit(ResetPasswordError(faillure)),
    );
  }
}
