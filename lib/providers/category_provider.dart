import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Future<void> fetchAndSetCategories() async {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/category');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(utf8.decode(response.bodyBytes))['_embedded']['category'] as List<dynamic>;
      final List<Category> loadedCategories = [];
      for (var categoryData in extractedData) {
        loadedCategories.add(Category(
          id: categoryData['id'],
          name: categoryData['name'],
        ));
      }
      _items = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}