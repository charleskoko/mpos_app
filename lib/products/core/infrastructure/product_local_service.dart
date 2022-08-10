import 'package:sembast/sembast.dart';
import 'package:collection/collection.dart';
import '../../../core/infrastructures/sembast_database.dart';
import '../domaine/product.dart';

class ProductLocalService {
  final SembastDatabase _sembastDatabase;
  final _store = intMapStoreFactory.store('products');
  ProductLocalService(this._sembastDatabase);
  static const int _itemsPerPage = 100;
  static const int _page = 1;

  Future<void> upsertProducts(List<Product> products) async {
    const sembastPage = _page - 1;

    await _store
        .records(products
            .mapIndexed((index, _) => index + _itemsPerPage * sembastPage))
        .put(
          _sembastDatabase.instance,
          products.map((e) => e.toJson()).toList(),
        );
  }

  Future<List<Product>> getProducts() async {
    const sembastPage = _page - 1;

    final records = await _store.find(
      _sembastDatabase.instance,
      finder: Finder(
        limit: _itemsPerPage,
        offset: _itemsPerPage * sembastPage,
      ),
    );

    return records.map((e) => Product.fromJson(e.value)).toList();
  }
}
