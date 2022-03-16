import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/navbar_drawer.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {

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
        title: const Text('Cửa Hàng Của Tôi'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(child: Text('Only Favorite'), value: FilterOptions.favorites,),
              const PopupMenuItem(child: Text('Show All'), value: FilterOptions.all,),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: NavbarDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : ProductsGrid(_showFavoriteOnly),
    );
  }
}
