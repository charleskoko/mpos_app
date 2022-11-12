import 'package:mpos_app/orders/core/domain/order.dart';

import '../../orders/core/domain/order_line_item.dart';
import '../../products/core/domaine/product.dart';
import '../../refund/core/domain/refund.dart';

class DashboardInfoTransformator {
  static double getIncomeOfTheDay(List<OrderProduct> orders) {
    double income = 0;
    for (OrderProduct order in orders) {
      List<OrderLineItem>? orderItem = order.orderLineItems;
      double orderTotal = 0;
      orderItem?.forEach((item) {
        orderTotal +=
            double.parse('${item.amount}') * double.parse('${item.price}');
      });
      income += orderTotal;
    }
    return income;
  }

  static double getRefundOfThePeriod(List<OrderProduct> orders) {
    double refundOfThePeriod = 0;
    for (OrderProduct order in orders) {
      List<Refund>? refunds = order.refunds!;
      double orderRefundTotal = 0;
      for (var item in refunds) {
        orderRefundTotal += item.amountRefunded!;
      }
      refundOfThePeriod += orderRefundTotal;
    }
    return refundOfThePeriod;
  }

  static int getNumberOfRefund(List<OrderProduct> orders) {
    int numberOfRefund = 0;
    for (OrderProduct order in orders) {
      List<Refund>? refunds = order.refunds!;
      numberOfRefund += order.refunds!.length;
    }
    return numberOfRefund;
  }

  static List<DashboardProductList>? getProductListDashboard(
      List<OrderProduct> orders) {
    List<DashboardProductList> dashboardProducts = [];
    for (OrderProduct order in orders) {
      for (OrderLineItem orderLineItem in order.orderLineItems!) {
        List<DashboardProductList> verificationList = dashboardProducts
            .where((element) =>
                element.productLabel!.toLowerCase() ==
                orderLineItem.productLabel!.toLowerCase())
            .toList();
        if (verificationList.length == 0) {
          DashboardProductList newDashboardProduct = DashboardProductList(
            price: orderLineItem.price,
            product: orderLineItem.product,
            productLabel: orderLineItem.productLabel,
            numberOfOrder: orderLineItem.amount,
            revenue: 300.0,
            total: orderLineItem.price * orderLineItem.amount,
          );

          dashboardProducts.add(newDashboardProduct);
        }
        if (verificationList.length != 0) {
          DashboardProductList currentProductList = verificationList[0];
          verificationList[0].numberOfOrder =
              verificationList[0].numberOfOrder! + orderLineItem.amount;
          if (currentProductList.product?.id == null) {
            verificationList[0].total =
                verificationList[0].total! + orderLineItem.price;
          }
          if (currentProductList.product?.id != null) {
            verificationList[0].total =
                verificationList[0].numberOfOrder! * currentProductList.price!;
          }
          int indexCurrentProductList = dashboardProducts.indexWhere(
              (element) =>
                  element.productLabel!.toLowerCase() ==
                  orderLineItem.productLabel!.toLowerCase());
          dashboardProducts[indexCurrentProductList] = currentProductList;
        }
      }
    }
    return dashboardProducts;
  }
}

class DashboardProductList {
  Product? product;
  String? productLabel;
  double? price;
  double? numberOfOrder;
  double? total;
  double? revenue;

  DashboardProductList({
    required this.price,
    required this.product,
    required this.productLabel,
    required this.numberOfOrder,
    required this.total,
    required this.revenue,
  });

  DashboardProductList.fromJson(Map<String, dynamic> jsonObject) {
    product = Product.fromJson(jsonObject["product"]);
    numberOfOrder = jsonObject["number_of_order"];
    price = jsonObject["price"];
    revenue = jsonObject["revenue"];
    productLabel = jsonObject["product_label"];
    total = jsonObject["total"];
  }
}
