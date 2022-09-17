import 'package:mpos_app/orders/core/domain/order.dart';

import '../../orders/core/domain/order_line_item.dart';
import '../../products/core/domaine/product.dart';

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

  static List<DashboardProductList>? getProductListDashboard(
      List<OrderProduct> orders) {
    List<DashboardProductList> dashboardProducts = [];
    for (OrderProduct order in orders) {
      for (OrderLineItem orderLineItem in order.orderLineItems!) {
        List<DashboardProductList> verificationList = dashboardProducts
            .where(
                (element) => element.product!.id == orderLineItem.product!.id)
            .toList();
        if (verificationList.length == 0) {
          DashboardProductList newDashboardProduct = DashboardProductList(
            product: orderLineItem.product,
            numberOfOrder: orderLineItem.amount,
            revenue: 300.0,
          );
          dashboardProducts.add(newDashboardProduct);
        }
        if (verificationList.length != 0) {
          DashboardProductList currentProductList = verificationList[0];
          currentProductList.numberOfOrder =
              currentProductList.numberOfOrder! + orderLineItem.amount;
          int indexCurrentProductList = dashboardProducts.indexWhere(
              (element) => element.product!.id == orderLineItem.product!.id);
          dashboardProducts[indexCurrentProductList] = currentProductList;
        }
      }
    }
    return dashboardProducts;
  }
}

class DashboardProductList {
  Product? product;
  double? numberOfOrder;
  double? revenue;

  DashboardProductList({
    required this.product,
    required this.numberOfOrder,
    required this.revenue,
  });

  DashboardProductList.fromJson(Map<String, dynamic> jsonObject) {
    product = Product.fromJson(jsonObject["product"]);
    numberOfOrder = jsonObject["number_of_order"];
    revenue = jsonObject["revenue"];
  }
}
