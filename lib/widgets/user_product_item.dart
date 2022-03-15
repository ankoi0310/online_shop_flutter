import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/product_edit_screen.dart';

class UserProductItemWidget extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;

  UserProductItemWidget(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(ProductEditScreen.routeName, arguments: id),
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor),
            IconButton(
                onPressed: () async {
                  try {
                    String message = await Provider.of<ProductsProvider>(
                            context,
                            listen: false)
                        .deleteProduct(id);
                    if (message != '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    }
                  } catch (error) {
                    throw Exception('Deleting failed');
                  }
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
