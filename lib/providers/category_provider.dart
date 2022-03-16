import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  Future<void> fetchAndSetCategories() async {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/product-category');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Category> loadedCategories = [];
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(Category(
          id: categoryData['id'],
          name: categoryData['name'],
        ));
      });
      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}