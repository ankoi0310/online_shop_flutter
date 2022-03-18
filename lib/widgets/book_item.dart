import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/book_detail_screen.dart';
import '../models/book.dart';

class BookItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<Book>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(BookDetailScreen.routeName, arguments: book.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: GridTile(
          child: Image.network(
            book.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text(book.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),),
            backgroundColor: Colors.black54,
            leading: Consumer<Book>(builder: (ctx, book, child) =>
              IconButton(
                icon: Icon(book.isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () => book.toggleFavoriteStatus(),
              ),
            ),
          ),
        ),
      ),
    );
  }

}