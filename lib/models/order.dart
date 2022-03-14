import 'dart:convert';
import 'package:flutter/material.dart';

import 'cart.dart';

class Order {
  String orderTrackingNumber;
  double totalPrice;
  List<CartItem> products;
  DateTime dateTime;

  Order({required this.orderTrackingNumber, required this.totalPrice, required this.products, required this.dateTime,});

  Map toJson() => {
    'orderTrackingNumber': orderTrackingNumber,
    'totalPrice': totalPrice,
    'products': products,
    'dateTime': dateTime.toIso8601String(),
  };

}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(0, Order(orderTrackingNumber: DateTime.now().microsecondsSinceEpoch.toString(),
      totalPrice: total, products: cartProducts, dateTime: DateTime.now(),),);
    print(json.encode(_orders));
    notifyListeners();
  }
}