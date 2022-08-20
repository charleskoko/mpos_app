import 'package:mpos_app/orders/core/domain/not_processed_order.dart';
import 'package:sembast/sembast.dart';
import '../../../core/infrastructures/sembast_database.dart';
import '../domain/selected_order_item.dart';

class NotProcessedOrderLocalservice {
  final SembastDatabase _sembastDatabase;
  static const String order_store_name = 'notProcessedOrder';
  final _store = intMapStoreFactory.store(order_store_name);
  NotProcessedOrderLocalservice(this._sembastDatabase);

  Future<void> insert(
      {required List<SelectedOrderItem> orderLineItems,
      required String label}) async {
    NotProcessedOrder notProcessedOrder = NotProcessedOrder(
        label: label,
        selectedOrderItem: orderLineItems,
        createdAt: DateTime.now());
    print(notProcessedOrder.toJson());
    final result = await _store.add(
      _sembastDatabase.instance,
      notProcessedOrder.toJson(),
    );
    print(result);
  }

  Future<int> update(NotProcessedOrder order) async {
    final finder = Finder(filter: Filter.byKey(order.id));
    final result = await _store.update(
      _sembastDatabase.instance,
      order.toJson(),
      finder: finder,
    );

    return result;
  }

  Future<void> delete(NotProcessedOrder order) async {
    final finder = Finder(filter: Filter.byKey(order.id));
    await _store.delete(
      _sembastDatabase.instance,
      finder: finder,
    );
  }

  Future<List<NotProcessedOrder>> getAllOrderSortedByLabel() async {
    final finder = Finder(sortOrders: [
      SortOrder(
        'label',
      )
    ]);
    final recordsSnapshots = await _store.find(
      _sembastDatabase.instance,
      finder: finder,
    );
    List<NotProcessedOrder> orders = [];
    recordsSnapshots.forEach((element) {
      orders.add(NotProcessedOrder.fromJson(element.value));
    });

    return orders;
  }
}
