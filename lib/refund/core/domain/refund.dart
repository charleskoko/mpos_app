class Refund {
  String? id;
  String? reason;
  double? amountRefunded;
  String? orderId;
  DateTime? createdAt;

  Refund({
    this.reason,
    this.amountRefunded,
    this.orderId,
    this.createdAt,
  });

  Refund.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    reason = jsonObject["reason"].toString();
    amountRefunded = double.tryParse(jsonObject["amount_refunded"].toString());
    orderId = jsonObject["order_id"];
    createdAt = DateTime.parse(jsonObject["created_at"]).toLocal();
  }

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'amount_refunded': amountRefunded,
        'order_id': orderId,
        'created_at': createdAt,
      };

  static List<Refund>? refunds(List<dynamic> dynamicList) {
    List<Refund> refunds =
        dynamicList.map((element) => Refund.fromJson(element)).toList();
    refunds.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return refunds;
  }
}
