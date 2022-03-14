import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/products_provider.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_overview_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';
import 'screens/user_product_screen.dart';
import 'screens/product_edit_screen.dart';
import 'models/cart.dart';
import 'models/order.dart';

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
        ChangeNotifierProvider(create: (BuildContext context)=> ProductsProvider(),),
        ChangeNotifierProvider(create: (BuildContext context)=> Cart(),),
        ChangeNotifierProvider(create: (BuildContext context)=> Orders(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Dosis',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.redAccent),
        ),
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          ProductEditScreen.routeName: (ctx) => ProductEditScreen(),
        },
      ),
    );
  }
}