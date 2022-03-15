import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/order.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget  {
  static const routeName = '/cart';

  @override
  State<StatefulWidget> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total'),
      ),
      body: Column(children: <Widget>[
        Card(
          margin: const EdgeInsets.all(15.0),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 20),),
                const Spacer(),
                Chip(label: Text('\$${cart.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6!.color),), backgroundColor: Theme.of(context).primaryColor,),
                FlatButton(
                  child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW', style: TextStyle(color: Theme.of(context).primaryColor),),
                  onPressed: (cart.totalPrice <=0 || _isLoading) ? null : () async {
                    await Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalPrice);
                    cart.clear();
                    setState(() { _isLoading = false; });
                  },
                )
              ]
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, idx) => CartItemWidget(cart.items.values.toList()[idx].productId, cart.items.keys.toList()[idx], cart.items.values.toList()[idx].name, cart.items.values.toList()[idx].quantity, cart.items.values.toList()[idx].unitPrice),
            itemCount: cart.itemCount,
          )
        ),
      ]),
    );
  }
}
