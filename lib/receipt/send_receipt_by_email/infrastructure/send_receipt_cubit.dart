import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/receipt/send_receipt_by_email/infrastructure/send_receipt_by_email_repository_impl.dart';

import '../../../authentication/domain/authentication_error.dart';

part 'send_receipt_state.dart';

class SendReceiptCubit extends Cubit<SendReceiptState> {
  final SendReceiptByEmailRepositoryImpl _sendReceiptByEmailRepository;
  SendReceiptCubit(this._sendReceiptByEmailRepository)
      : super(SendReceiptInitial());

  Future<void> sendReceipt(Map<String, dynamic> data) async {
    emit(SendReceiptLoading());
    final sendReceiptRequest =
        await _sendReceiptByEmailRepository.sendReceipt(data);
    sendReceiptRequest.fold(
      (l) => emit(SendReceiptLoaded()),
      (r) => emit(SendReceiptFaillure(r)),
    );
  }

  Future<void> initialize() async {
    emit(SendReceiptInitial());
  }
}
