import '../../../products/core/domaine/product.dart';

class SelectedOrderItem {
  Product? product;
  double? amount;
  double? price;

  SelectedOrderItem(this.product, this.amount, this.price);

  set setAmount(double amount) {
    this.amount = amount;
  }

  void incrementAmount() {
    amount = amount! + 1;
    print(amount);
  }

  void decrementAmount() {
    if (amount! > 1) {
      amount = amount! - 1;
    }
  }

  Map<String, dynamic> mapToOrderLineItemBackend() => {
        'product_id': product?.id,
        'amount': amount,
        'price': price,
      };
}
