import 'package:dartz/dartz.dart';
import 'package:mpos_app/authentication/domain/credential.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_local_service.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_remote_service.dart';

import '../../core/domain/user.dart';
import '../../core/infrastructures/network_exception.dart';
import '../../core/infrastructures/remote_response.dart';
import '../domain/authentication_error.dart';

class AuthenticationRepository {
  final AuthenticationLocalService _authenticationLocalService;
  final AuthenticationRemoteService _authenticationRemoteService;

  AuthenticationRepository(
    this._authenticationLocalService,
    this._authenticationRemoteService,
  );

  Future<User?> getLoggedUser() async {
    return await _authenticationLocalService.readAuthUser();
  }

  Future<Either<User, AuthenticationError>> loginOrRegister(
      Credential credential) async {
    try {
      final loginRequestResponse =
          await _authenticationRemoteService.login(credential: credential);
      if (loginRequestResponse is ConnectionResponse) {
        User authUser;
        await _authenticationLocalService.saveAuthUser(
            user: authUser = loginRequestResponse.response['user']);
        await _authenticationLocalService.saveBearerToken(
            bearerToken: loginRequestResponse.response['token']);

        return left(authUser);
      } else if (loginRequestResponse is NotAuthorized) {
        return right(AuthenticationError('not authorized'));
      } else {
        return right(AuthenticationError('no connection'));
      }
    } on RestApiException catch (exception) {
      return right(
        AuthenticationError(exception.message ?? 'no error message'),
      );
    }
  }

  Future<void> logout() async {
    await _authenticationRemoteService.logout();
    await _authenticationLocalService.clearAuthUserStored();
    await _authenticationLocalService.clearStoredBearerToken();
  }

  Future<void> offLineLogout() async {
    await _authenticationLocalService.clearAuthUserStored();
    await _authenticationLocalService.clearStoredBearerToken();
  }
}
