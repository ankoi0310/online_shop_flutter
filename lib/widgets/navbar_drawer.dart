import 'package:flutter/material.dart';
import 'package:online_shop/screens/book_overview_screen.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../screens/user_book_screen.dart';

class NavbarDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<CategoryProvider>(context);
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(title: const Text('Navigation'),),
        const Divider(),
        ListTile(title: const Text('Home'), leading: const Icon(Icons.home), onTap: () => Navigator.pushReplacementNamed(context, '/'),),
        const Divider(),
        Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent,),
            child: ExpansionTile(
              title: const Text('Find by category'),
              leading: const Icon(Icons.category_outlined),
              children: <Widget>[
                ListTile(
                  leading: const Padding(padding: EdgeInsets.only(left: 20)),
                  title: const Text('Tất cả'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookOverviewScreen(categoryId: 0))),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: categoriesData.items.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) => ListTile(
                      leading: const Padding(padding: EdgeInsets.only(left: 20)),
                      title: Text(categoriesData.items[i].name),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookOverviewScreen(categoryId: categoriesData.items[i].id))),
                    ),
                  ),
                ),
              ],
            )
        ),
        const Divider(),
        ListTile(
          title: const Text('Manage Book'),
          leading: const Icon(Icons.collections_bookmark),
          onTap: () => Navigator.pushReplacementNamed(context, UserBookScreen.routeName),),
      ],),
    );
  }
}