part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationValidated extends AuthenticationState {
  final User? loggedUser;
  AuthenticationValidated(this.loggedUser);
}

class AuthenticationNotValidated extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {
  final String message;
  AuthenticationFailed({this.message = 'no faillure message'});
}
