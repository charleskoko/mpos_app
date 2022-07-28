import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_repository.dart';

import '../../core/domain/user.dart';
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
    final fetchUserAuthenticationInfoOrFaillure =
        await _authenticationRepository.loginOrRegister(credential);
    fetchUserAuthenticationInfoOrFaillure.fold(
      (authenticatedUserInfo) =>
          emit(AuthenticationValidated(authenticatedUserInfo)),
      (faillureMessage) =>
          emit(AuthenticationFailed(message: faillureMessage.getMessage)),
    );
  }

  Future<void> logout() async {
    emit(AuthenticationLoading());
    await _authenticationRepository.logout();
    emit(AuthenticationNotValidated());
  }
}
