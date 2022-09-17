import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_repository.dart';

import '../../core/domain/user.dart';
import '../../core/infrastructures/network_exception.dart';
import '../domain/credential.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  AuthenticationCubit(this._authenticationRepository)
      : super(AuthenticationInitial());

  Future<void> isUserLoggedIn() async {
    emit(AuthenticationLoading());
    final User? user = await _authenticationRepository.getLoggedUser();
    if (user == null) {
      emit(AuthenticationNotValidated());
    }
    if (user != null) {
      emit(AuthenticationValidated(user));
    }
  }

  Future<void> login(Credential credential) async {
    emit(AuthenticationLoading());
    final userAuthenticationInfoOrFaillure =
        await _authenticationRepository.login(credential);
    userAuthenticationInfoOrFaillure.fold(
      (authenticatedUserInfo) =>
          emit(AuthenticationValidated(authenticatedUserInfo)),
      (faillureMessage) =>
          emit(AuthenticationFailed(message: faillureMessage.getMessage)),
    );
  }

  Future<void> registration(Credential credential) async {
    emit(AuthenticationLoading());
    final userAuthenticationInfoOrFaillure =
        await _authenticationRepository.register(credential);
    userAuthenticationInfoOrFaillure.fold(
      (authenticatedUserInfo) =>
          emit(AuthenticationValidated(authenticatedUserInfo)),
      (faillureMessage) {
        emit(AuthenticationFailed(message: faillureMessage.getMessage));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthenticationLoading());
    try {
      await _authenticationRepository.logout();
      emit(AuthenticationNotValidated());
      // ignore: unused_catch_clause
    } on RestApiException catch (exception) {
      _authenticationRepository.offLineLogout();
      emit(AuthenticationNotValidated());
    }
  }
}
