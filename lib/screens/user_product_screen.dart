import 'package:flutter/material.dart';
import 'package:online_shop/screens/product_edit_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/navbar_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add), onPressed: () => Navigator.of(context).pushNamed(ProductEditScreen.routeName),),
        ],
      ),
      drawer: NavbarDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (ctx, i) => Column(
            children: <Widget>[
              UserProductItemWidget(productsData.items[i].name, productsData.items[i].imageUrl,),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}