import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  int id;
  String name;
  String description;
  double unitPrice;
  String imageUrl;
  bool isFavorite;

  Product({required this.id, required this.name, required this.description, required this.unitPrice,
    required this.imageUrl, this.isFavorite = false });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
