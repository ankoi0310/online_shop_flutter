import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../widgets/navbar_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your orders'),),
      drawer: NavbarDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItemWidget(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}