class Product {
  String? id;
  String? label;
  double? salePrice;
  double? purchasePrice;

  Product({
    this.id,
    this.label,
    this.salePrice,
    this.purchasePrice,
  });

  Product.fromJson(Map<String, dynamic>? jsonObject) {
    id = jsonObject?["id"].toString();
    label = jsonObject?["label"].toString();
    salePrice = double.tryParse(jsonObject?["sale_price"].toString() ?? '0');
    purchasePrice = (jsonObject?["purchase_price"] != null)
        ? double.parse(jsonObject?["purchase_price"].toString() ?? '0')
        : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'sale_price': salePrice.toString(),
        'purchase_price': purchasePrice.toString(),
      };
}
