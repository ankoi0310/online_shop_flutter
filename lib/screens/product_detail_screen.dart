import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    int productId = ModalRoute.of(context)!.settings.arguments as int;
    Product loadedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 300, width: double.infinity, child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),),
            const SizedBox(height: 10,),
            Text('\$${loadedProduct.unitPrice}', style: const TextStyle(fontSize: 20, color: Colors.grey),),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: const Text('Product description', style: TextStyle(fontSize: 18),),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ]
        ),
      ),
    );
  }
  
}