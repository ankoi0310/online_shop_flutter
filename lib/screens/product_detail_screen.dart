import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
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
            // sized box with 50%

            SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),),
            const SizedBox(height: 10,),
            Text('${loadedProduct.unitPrice}'.toVND(unit: 'VNĐ'), style: const TextStyle(fontSize: 20, color: Colors.grey),),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: Text(loadedProduct.description, style: const TextStyle(fontSize: 18),),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ]
        ),
      ),
    );
  }
  
}