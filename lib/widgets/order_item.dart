import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  OrderItemWidget(this.order);

  @override
  State<StatefulWidget> createState() => _OrderItemWidget();
}

class _OrderItemWidget extends  State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.totalPrice}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(icon: const Icon(Icons.expand_more), onPressed: () => setState(() { _expanded = !_expanded; }),),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products.map((product) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('${product.quantity}x \$${product.unitPrice}', style: const TextStyle(fontSize: 18, color: Colors.grey))
                  ],
                )).toList(),
              ),
            )
        ],
      ),
    );
  }
}