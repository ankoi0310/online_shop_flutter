import 'package:flutter/material.dart';
import 'package:online_shop/screens/user_product_screen.dart';

class NavbarDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(title: const Text('Navigation'),),
        const Divider(),
        ListTile(title: const Text('Shop'), leading: const Icon(Icons.shop), onTap: () => Navigator.pushReplacementNamed(context, '/'),),
        const Divider(),
        ListTile(title: const Text('Manage Product'), leading: const Icon(Icons.edit), onTap: () => Navigator.pushReplacementNamed(context, UserProductScreen.routeName),),
      ],),
    );
  }
}