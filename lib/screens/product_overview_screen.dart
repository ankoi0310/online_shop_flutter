import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/navbar_drawer.dart';
import '../models/cart.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductOverviewScreen();

}

class _ProductOverviewScreen extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() { _isLoading = true;});
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((value) => setState(() { _isLoading = false; }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(child: Text('Only Favorite'), value: FilterOptions.Favorites,),
              const PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, childWidget) => Badge(
              child: childWidget!,
              value: cartData.itemCount.toString(),
              color: Colors.amberAccent,
            ),
            child: IconButton(
                onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
                icon: const Icon(Icons.shopping_cart)),
          ),
        ],
      ),
      drawer: NavbarDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showFavoriteOnly),
    );
  }
}
