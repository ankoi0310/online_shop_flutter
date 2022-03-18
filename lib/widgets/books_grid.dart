import 'package:flutter/material.dart';
import 'package:online_shop/providers/category_provider.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../widgets/book_item.dart';

class BooksGrid extends StatelessWidget {
  final bool _showFavoriteOnly;
  final int _categoryId;

  BooksGrid(this._showFavoriteOnly, this._categoryId);

  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<BookProvider>(context);
    final books = booksData.findByCategory(_categoryId, _showFavoriteOnly);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (ctx, idx) =>
        ChangeNotifierProvider.value(value: books[idx], child: BookItem()),
      itemCount: books.length,
    );
  }
  
}