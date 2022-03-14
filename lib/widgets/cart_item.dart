import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartItemWidget extends StatelessWidget {
  final int productId;
  final int keyProductId;
  final String name;
  final int quantity;
  final double unitPrice;

  const CartItemWidget(this.productId, this.keyProductId, this.name, this.quantity, this.unitPrice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) => AlertDialog(
          content: Text('Do you want to remove the item from the cart?'),
          actions: <Widget>[
            FlatButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
            FlatButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
          ],
        ));
      },
      onDismissed: (direction) { Provider.of<Cart>(context, listen: false).removeItem(keyProductId); },
      background: Container(
        color: Theme.of(context).errorColor,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 40,),
        // padding: const EdgeInsets.only(right: 20),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: FittedBox(
                  child: Text('\$$unitPrice',),
                ),
              ),
            ),
            title: Text(name),
            subtitle: Text('Total: \$${(unitPrice * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}