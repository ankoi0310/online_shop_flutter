import 'package:flutter/material.dart';
import 'package:online_shop/providers/category_provider.dart';
import 'package:provider/provider.dart';

import 'providers/book_provider.dart';
import 'screens/book_detail_screen.dart';
import 'screens/book_overview_screen.dart';
import 'screens/user_book_screen.dart';
import 'screens/book_edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context)=> BookProvider(),),
        ChangeNotifierProvider(create: (BuildContext context)=> CategoryProvider(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'BeVietnamPro',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.redAccent),
        ),
        home: BookOverviewScreen(categoryId: 0),
        routes: {
          BookDetailScreen.routeName: (ctx) => BookDetailScreen(),
          UserBookScreen.routeName: (ctx) => UserBookScreen(),
          BookEditScreen.routeName: (ctx) => BookEditScreen(),
        },
      ),
    );
  }
}
