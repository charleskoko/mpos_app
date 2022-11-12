import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/domain/refund.dart';
import '../../core/domain/refund_error.dart';
import '../../core/infrastructure/refund_repository.dart';

part 'refund_store_state.dart';

class RefundStoreCubit extends Cubit<RefundStoreState> {
  final RefundRepository _refundRepository;
  RefundStoreCubit(this._refundRepository) : super(RefundStoreInitial());

  Future<void> storeRefund(Map<String, dynamic> data) async {
    emit(RefundStoreLoading());
    final storeRefundResponse =
        await _refundRepository.storeRefund(refund: data);
    storeRefundResponse.fold(
      (refund) => emit(RefundStoreLoaded(refund)),
      (refundError) => RefundStoreError(refundError),
    );
  }
}
