import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http_client;

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
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    Uri url = Uri.parse('http://localhost:8080/api/orders');
    final response = await http_client.get(url);
    // print(json.decode(response.body));
    final extractedDate = json.decode(response.body)['_embedded']['orders'] as List<dynamic>;
    if (extractedDate.length == 0){
      return;
    }
    final List<Order> loadedOrders = [];
    extractedDate.forEach((element) {
      List<CartItem> listCartItems = (element['orderItems'] as List<dynamic>).map((element) => CartItem(
        productId: element['productId'],
        name: element['productId'].toString(),
        quantity: element['quantity'],
        unitPrice: element['unitPrice'],
        imageUrl: element['imageUrl'],)
      ).toList();

      loadedOrders.add(Order(
        orderTrackingNumber: element['orderTrackingNumber'],
        totalPrice: element['totalPrice'],
        dateTime: DateTime.parse(element['dateCreated']).toLocal(),
        products: listCartItems,
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();

  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) {
    Uri url = Uri.parse('http://localhost:8080/api/checkout/purchase');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return http_client.post(url, headers: headers, body: json.encode({
      'user': {'email': 'ray@email.com'},
      "shippingAddress": {
        "street": "21231 Le Duan, DISTRICT 1", "city": "HO CHI MINH", "state": "Alberta", "country": "Canada", "zipCode": "70000"
      },
      "billingAddress": {
        "street": "21231 Le Duan, DISTRICT 1", "city": "HO CHI MINH", "state": "Alberta", "country": "Canada", "zipCode": "70000"
      },
      "order": {"totalQuantity": 0, "totalPrice": total },
      'orderItems': cartProducts.map((e) => {
        'imageUrl': e.imageUrl,
        'quantity': e.quantity,
        'unitPrice': e.unitPrice,
        'productId': e.productId,
      }).toList(),
    })).then((result) {
      String orderTrackingNumber = DateTime.now().millisecondsSinceEpoch.toString();
      DateTime dateCreated = DateTime.now();

      try {
        orderTrackingNumber = json.decode(result.body)['orderTrackingNumber'];
        dateCreated = DateTime.parse(json.decode(result.body)['dateCreated']).toLocal();
      } on FormatException catch (_) {
        print('Message return is not a valid JSON format');
      }
      _orders.insert(0, Order(orderTrackingNumber: orderTrackingNumber, totalPrice: total, dateTime: dateCreated, products: cartProducts));
      // print(json.encode(_orders));
      notifyListeners();

    }).catchError((error) => throw error);
  }
}