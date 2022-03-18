import 'package:flutter/material.dart';
import 'package:online_shop/models/category.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/books_grid.dart';
import '../widgets/navbar_drawer.dart';

enum FilterOptions {
  favorites,
  all,
}

class BookOverviewScreen extends StatefulWidget {
  final int categoryId;

  BookOverviewScreen({required this.categoryId});

  @override
  State<StatefulWidget> createState() => _BookOverviewScreen();

}

class _BookOverviewScreen extends State<BookOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() { _isLoading = true;});
      Provider.of<CategoryProvider>(context).fetchAndSetCategories();
      Provider.of<BookProvider>(context).fetchAndSetBooks().then((value) => setState(() { _isLoading = false; }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int categoryId = widget.categoryId;
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
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : BooksGrid(_showFavoriteOnly, categoryId),
    );
  }
}
