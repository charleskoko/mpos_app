class Product {
  String? id;
  String? label;
  double? price;

  Product({
    this.id,
    this.label,
    this.price,
  });

  Product.fromJson(Map<String, dynamic>? jsonObject) {
    id = jsonObject?["id"].toString();
    label = jsonObject?["label"].toString();
    price = double.parse(jsonObject?["price"] ?? '0');
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'price': price,
      };
}
