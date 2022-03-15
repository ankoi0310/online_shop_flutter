import 'dart:convert';
import 'package:http/http.dart' as http_client;
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 1,
      name: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      unitPrice: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 2,
      name: 'Trousers',
      description: 'A nice pair of trousers.',
      unitPrice: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 3,
      name: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      unitPrice: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 4,
      name: 'A Pan',
      description: 'Prepare any meal you want.',
      unitPrice: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

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
    Uri url = Uri.parse('http://localhost:8080/api/product');
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
      Uri url = Uri.parse('http://localhost:8080/api/products/$id');
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
        throw error;
      }
    } else {
      print("problem with updating product");
    }
  }

  Future<void> fetchAndSetProducts() async {
    Uri url = Uri.parse(
        'http://localhost:8080/api/products/search/findByCategoryId?id=5');
    try {
      final response = await http_client.get(url);
      print(json.decode(response.body)['_embedded']['products']);
      final extractedData =
          json.decode(response.body)['_embedded']['products'] as List<dynamic>;
      final List<Product> loadProducts = [];
      extractedData.forEach((element) {
        // print(element);
        loadProducts.add(Product(
          id: element['id'],
          name: element['name'],
          description: element['description'],
          unitPrice: element['unitPrice'],
          imageUrl: element['imageUrl'],
          isFavorite: element['favorite'],
        ));
      });
      _items = loadProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<String> deleteProduct(int id) async {
    Uri url = Uri.parse('http://localhost:8080/api/products/$id');

    String message = '';
    try {
      final response = await http_client.delete(url);
      if (response.statusCode == 204) {
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        // print(json.decode(response.body));
        message = json.decode(response.body)['message'];
      }
      return message;
    } catch (error) {
      throw error;
    }
  }
}
