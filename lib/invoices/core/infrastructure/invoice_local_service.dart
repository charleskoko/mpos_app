import 'package:mpos_app/invoices/core/domain/invoice.dart';
import 'package:sembast/sembast.dart';
import '../../../core/infrastructures/sembast_database.dart';
import 'package:collection/collection.dart';

class InvoiceLocalService {
  final SembastDatabase _sembastDatabase;
  final _store = intMapStoreFactory.store('invoices');
  InvoiceLocalService(this._sembastDatabase);
  static const int _itemsPerPage = 100;
  static const int _page = 1;

  Future<void> upsertInvoices(List<Invoice> invoices) async {
    const sembastPage = _page - 1;

    await _store
        .records(invoices
            .mapIndexed((index, _) => index + _itemsPerPage * sembastPage))
        .put(
          _sembastDatabase.instance,
          invoices.map((e) => e.toJson()).toList(),
        );
  }

  Future<List<Invoice>> getInvoices() async {
    const sembastPage = _page - 1;

    final records = await _store.find(
      _sembastDatabase.instance,
      finder: Finder(
        limit: _itemsPerPage,
        offset: _itemsPerPage * sembastPage,
      ),
    );

    return records.map((e) => Invoice.fromJson(e.value)).toList();
  }
}
