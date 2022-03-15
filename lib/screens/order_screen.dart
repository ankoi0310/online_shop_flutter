import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../widgets/navbar_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() { _isLoading = true; });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() { _isLoading = false; });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your orders'),),
      drawer: NavbarDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemBuilder: (ctx, i) => OrderItemWidget(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}