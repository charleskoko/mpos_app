part of 'generate_reset_password_code_cubit.dart';

@immutable
abstract class GenerateResetPasswordCodeState {}

class GenerateResetPasswordCodeInitial extends GenerateResetPasswordCodeState {}

class GenerateResetPasswordCodeLoading extends GenerateResetPasswordCodeState {}

class GenerateResetPasswordCodeLoaded extends GenerateResetPasswordCodeState {}

class GenerateResetPasswordCodeError extends GenerateResetPasswordCodeState {
  final AuthenticationError authenticationError;
  GenerateResetPasswordCodeError(this.authenticationError);
}
