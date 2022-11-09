import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/dashboard/shared/dashboard_info_transformator.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../orders/core/infrastructure/order_repository.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final OrderRepository _orderRepository;
  DashboardCubit(this._orderRepository) : super(DashboardInfoInitial());

  Future<void> dashboardData(
      {required String selectedDate, required String period}) async {
    emit(DashboardInfoLoading());
    try {
      final dashboardData = await _orderRepository.dashboardInfo(
        selectedDate: selectedDate,
        period: period,
      );
      dashboardData.fold(
        (fresh) {
          int numberOfSalesOfTheDay = fresh.entity.length;
          double incomeOftheday =
              DashboardInfoTransformator.getIncomeOfTheDay(fresh.entity);
          List<DashboardProductList>? productsList =
              DashboardInfoTransformator.getProductListDashboard(fresh.entity);
          emit(DashboardInfoLoaded(
            incomeOftheday: incomeOftheday,
            numberOfSalesOfTheDay: numberOfSalesOfTheDay,
            products: productsList,
          ));
        },
        (invoiceError) {
          emit(
            DashboardInfoLoaded(
              incomeOftheday: 0,
              numberOfSalesOfTheDay: 0,
              products: [],
              errorMessage: invoiceError.message,
            ),
          );
        },
      );
    } on RestApiException catch (exception) {
      emit(
        DashboardInfoLoaded(
          incomeOftheday: 0,
          numberOfSalesOfTheDay: 0,
          products: [],
          errorMessage: exception.message,
        ),
      );
    }
  }
}
