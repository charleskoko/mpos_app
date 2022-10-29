part of 'send_receipt_cubit.dart';

@immutable
abstract class SendReceiptState {}

class SendReceiptInitial extends SendReceiptState {}

class SendReceiptLoading extends SendReceiptState {}

class SendReceiptLoaded extends SendReceiptState {}

class SendReceiptFaillure extends SendReceiptState {
  final AuthenticationError authenticationError;
  SendReceiptFaillure(this.authenticationError);
}
