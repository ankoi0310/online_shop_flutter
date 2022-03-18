import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../screens/book_edit_screen.dart';

class UserBookItemWidget extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;

  UserBookItemWidget(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(BookEditScreen.routeName, arguments: id),
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor),
            IconButton(
                onPressed: () async {
                  try {
                    String message = await Provider.of<BookProvider>(
                            context,
                            listen: false)
                        .deleteBook(id);
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
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
