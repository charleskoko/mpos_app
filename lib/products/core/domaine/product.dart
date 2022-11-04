class Product {
  String? id;
  String? label;
  double? salePrice;
  double? purchasePrice;
  bool? isDeleted;

  Product({
    this.id,
    this.label,
    this.salePrice,
    this.purchasePrice,
    this.isDeleted,
  });

  Product.fromJson(Map<String, dynamic>? jsonObject) {
    id = jsonObject?["id"].toString();
    label = jsonObject?["label"].toString();
    salePrice = double.parse(jsonObject?["sale_price"].toString() ?? '0');
    purchasePrice =
        double.parse(jsonObject?["purchase_price"].toString() ?? '0');
    //isDeleted = jsonObject?["is_deleted"];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'sale_price': salePrice.toString(),
        'purchase_price': purchasePrice.toString(),
        'is_deleted': isDeleted,
      };
}
