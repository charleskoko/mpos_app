import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'store_order_state.dart';

class StoreOrderCubit extends Cubit<StoreOrderState> {
  StoreOrderCubit() : super(StoreOrderInitial());
}
