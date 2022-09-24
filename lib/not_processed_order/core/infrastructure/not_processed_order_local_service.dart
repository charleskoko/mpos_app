import 'package:mpos_app/not_processed_order/core/domain/not_processed_order.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import '../../../core/infrastructures/sembast_database.dart';
import '../../../orders/core/domain/selected_order_item.dart';

class NotProcessedOrderLocalservice {
  final SembastDatabase _sembastDatabase;
  static const String order_store_name = 'notProcessedOrder';
  final _store = intMapStoreFactory.store(order_store_name);
  NotProcessedOrderLocalservice(this._sembastDatabase);

  Future<void> insert(
      {required List<SelectedOrderItem> orderLineItems,
      required String label}) async {
    NotProcessedOrder notProcessedOrder = NotProcessedOrder(
      id: Uuid().v1(),
      label: label,
      selectedOrderItem: orderLineItems,
      createdAt: DateTime.now(),
    );
    await _store.add(
      _sembastDatabase.instance,
      notProcessedOrder.toJson(),
    );
  }

  Future<int> update(NotProcessedOrder order) async {
    final finder = Finder(filter: Filter.equals('id', order.id));
    final result = await _store.update(
      _sembastDatabase.instance,
      order.toJson(),
      finder: finder,
    );
    return result;
  }

  Future<void> delete(NotProcessedOrder order) async {
    final finder = Finder(filter: Filter.equals('id', order.id));
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
