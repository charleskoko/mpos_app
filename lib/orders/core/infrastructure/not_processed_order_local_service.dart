import 'package:sembast/sembast.dart';
import '../../../core/infrastructures/sembast_database.dart';

class NotProcessedOrderLocalservice {
  final SembastDatabase _sembastDatabase;
  static const String order_store_name = 'notProcessedOrder';
  final _store = intMapStoreFactory.store(order_store_name);
  NotProcessedOrderLocalservice(this._sembastDatabase);
}
