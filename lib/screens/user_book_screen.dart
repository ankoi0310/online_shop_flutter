import 'package:flutter/material.dart';
import 'package:online_shop/screens/book_edit_screen.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../widgets/navbar_drawer.dart';
import '../widgets/user_book_item.dart';

class UserBookScreen extends StatelessWidget {
  static const routeName = '/user-book';

  Future<void> _refreshBooks(BuildContext context) async {
    await Provider.of<BookProvider>(context, listen: false)
        .fetchAndSetBooks();
  }

  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sách của bạn'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(BookEditScreen.routeName),
          ),
        ],
      ),
      drawer: NavbarDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshBooks(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: booksData.items.length,
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[
                UserBookItemWidget(
                  booksData.items[i].id,
                  booksData.items[i].title,
                  booksData.items[i].imageUrl,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
