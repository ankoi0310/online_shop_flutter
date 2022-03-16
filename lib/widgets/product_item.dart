import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,),
          footer: GridTileBar(
            title: Text(product.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),),
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(builder: (ctx, product, child) =>
              IconButton(
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () => product.toggleFavoriteStatus(),
              ),
            ),
          ),
        ),
      ),
    );
  }

}