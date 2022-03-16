import 'dart:convert';
import 'package:http/http.dart' as http_client;
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  // getter
  List<Product> get items {
    return [..._items];
  }

  // findById
  Product findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // getFavoriteItems
  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/product');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      final response = await http_client.post(url,
          headers: headers,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'unitPrice': product.unitPrice,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            'unitsInStock': 100,
            'active': true,
            'category': {"id": 5, "categoryName": "MobileProduct"}
          }));

      // print(json.decode(response.body));
      final res = json.decode(response.body);
      Product newProduct = Product(
          name: res['name'],
          description: res['description'],
          unitPrice: res['unitPrice'],
          imageUrl: res['imageUrl'],
          id: res['id']);
      _items.add(newProduct);
      // print(json.encode(newProduct));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(int id, Product newProduct) async {
    int prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      Uri url = Uri.parse('http://192.168.1.56:8080/api/products/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      try {
        await http_client.put(url,
            headers: headers,
            body: json.encode({
              'name': newProduct.name,
              'description': newProduct.description,
              'unitPrice': newProduct.unitPrice,
              'imageUrl': newProduct.imageUrl,
              'favorite': newProduct.isFavorite,
              'unitsInStock': 100,
              'active': true,
              'category': {"id": 5, "categoryName": "MobileProduct"}
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {
      print("problem with updating product");
    }
  }

  Future<void> fetchAndSetProducts() async {
    Uri url = Uri.parse(
        'http://192.168.1.56:8080/api/products');
    try {
      final response = await http_client.get(url);
      final extractedData = json.decode(utf8.decode(response.bodyBytes))['_embedded']['products'] as List<dynamic>;
      final List<Product> loadProducts = [];
      for (var element in extractedData) {
        loadProducts.add(Product(
          id: element['id'],
          name: element['name'],
          description: element['description'],
          unitPrice: element['unitPrice'],
          imageUrl: element['imageUrl'],
          isFavorite: element['favorite'],
        ));
      }
      _items = loadProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> deleteProduct(int id) async {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/products/$id');

    String message = '';
    try {
      final response = await http_client.delete(url);
      if (response.statusCode == 204) {
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        message = json.decode(utf8.decode(response.bodyBytes))['message'];
      }
      return message;
    } catch (error) {
      rethrow;
    }
  }
}
