import 'package:dartz/dartz.dart';
import 'package:mpos_app/authentication/domain/credential.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_local_service.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_remote_service.dart';

import '../../core/domain/user.dart';
import '../../core/infrastructures/network_exception.dart';
import '../../core/domain/remote_response.dart';
import '../domain/authentication_error.dart';
import '../domain/reset_password_data.dart';

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

  Future<Either<User, AuthenticationError>> login(Credential credential) async {
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
        return right(AuthenticationError('notAuthorized'));
      } else {
        return right(AuthenticationError('noConnection'));
      }
    } on RestApiException catch (exception) {
      return right(
        AuthenticationError(exception.message ?? 'noErrorMessage'),
      );
    }
  }

  Future<Either<User, AuthenticationError>> register(
      Credential credential) async {
    try {
      final registerRequestResponse =
          await _authenticationRemoteService.register(credential: credential);
      if (registerRequestResponse is ConnectionResponse) {
        User authUser;
        await _authenticationLocalService.saveAuthUser(
            user: authUser = registerRequestResponse.response['user']);
        await _authenticationLocalService.saveBearerToken(
            bearerToken: registerRequestResponse.response['token']);

        return left(authUser);
      } else if (registerRequestResponse is NotAuthorized) {
        return right(AuthenticationError('notAuthorized'));
      } else {
        return right(AuthenticationError('noConnection'));
      }
    } on RestApiException catch (exception) {
      return right(
        AuthenticationError(exception.message ?? 'noErrorMessage'),
      );
    }
  }

  Future<Either<String, AuthenticationError>> generateResetPasswordCode(
      {required Credential credential}) async {
    try {
      final generateResetPasswordCodeRequest =
          await _authenticationRemoteService.generateResetPasswordCode(
              credential: credential);
      if (generateResetPasswordCodeRequest is ConnectionResponse) {
        return left(generateResetPasswordCodeRequest.response);
      } else if (generateResetPasswordCodeRequest is NotAuthorized) {
        return right(AuthenticationError('notAuthorized'));
      } else {
        return right(AuthenticationError('noConnection'));
      }
    } on RestApiException catch (exception) {
      print(exception);
      return right(
        AuthenticationError(exception.message ?? 'noErrorMessage'),
      );
    }
  }

  Future<Either<String, AuthenticationError>> resetPassword(
      {required ResetPasswordData resetPassword}) async {
    try {
      final resetPasswordRequest = await _authenticationRemoteService
          .resetPassword(resetPassword: resetPassword);
      if (resetPasswordRequest is ConnectionResponse) {
        return left(resetPasswordRequest.response);
      } else if (resetPasswordRequest is NotAuthorized) {
        return right(AuthenticationError('notAuthorized'));
      } else {
        return right(AuthenticationError('noConnection'));
      }
    } on RestApiException catch (exception) {
      return right(
        AuthenticationError(exception.message ?? 'noErrorMessage'),
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
