class Product {
  String? id;
  String? label;
  double? salePrice;
  double? purchasePrice;
  bool? isDeleted;
  int? stock;

  Product({
    this.id,
    this.label,
    this.salePrice,
    this.purchasePrice,
    this.isDeleted,
    this.stock,
  });

  Product.fromJson(Map<String, dynamic>? jsonObject) {
    id = jsonObject?["id"].toString();
    label = jsonObject?["label"].toString();
    salePrice = double.parse(jsonObject?["sale_price"] ?? '0');
    purchasePrice = double.parse(jsonObject?["purchase_price"] ?? '0');
    isDeleted = jsonObject?["is_deleted"];
    stock = int.parse(jsonObject?["stock"]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'sale_price': salePrice.toString(),
        'purchase_price': purchasePrice.toString(),
        'is_deleted': isDeleted,
        'stock': stock
      };
}
