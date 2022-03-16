import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavoriteOnly;

  ProductsGrid(this._showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = _showFavoriteOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (ctx, idx) =>
        ChangeNotifierProvider.value(value: products[idx], child: ProductItem()),
      itemCount: products.length,
    );
  }
  
}