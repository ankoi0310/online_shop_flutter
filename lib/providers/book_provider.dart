import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_shop/models/category.dart';

import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _items = [];

  // getter
  List<Book> get items {
    return [..._items];
  }

  // findById
  Book findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // findByCategory
  List<Book> findByCategory(int categoryId, bool _showFavoriteOnly) {
    if (categoryId == 0) {
      return _showFavoriteOnly ? _items.where((element) => element.isFavorite).toList() : _items;
    } else {
      List<Book> temp = _items.where((element) => element.category.id == categoryId).toList();
      return _showFavoriteOnly ? temp.where((element) => element.isFavorite).toList() : temp;
    }
  }

  // getFavoriteItems
  List<Book> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addBook(Book book) async {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/book');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            'title': book.title,
            'description': book.description,
            'unitPrice': book.unitPrice,
            'author': book.author,
            'publicationDate': book.publicationDate,
            'imageUrl': book.imageUrl,
            'favorite': book.isFavorite,
            'category': book.category,
          }));

      final res = json.decode(utf8.decode(response.bodyBytes))['data'];
      Book newProduct = Book(
          title: res['title'],
          description: res['description'],
          unitPrice: res['unitPrice'],
          author: res['author'],
          publicationDate: res['publicationDate'],
          imageUrl: res['imageUrl'],
          id: res['id'],
          isFavorite: res['isFavorite'],
          category: Category(
            id: res['category']['id'],
            name: res['category']['name'],
          ),
          active: res['active']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateBook(int id, Book newBook) async {
    int prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      Uri url = Uri.parse('http://192.168.1.56:8080/api/book');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      try {
        await http.put(url,
            headers: headers,
            body: json.encode({
              'id': id,
              'title': newBook.title,
              'description': newBook.description,
              'unitPrice': newBook.unitPrice,
              'author': newBook.author,
              'publicationDate': newBook.publicationDate,
              'imageUrl': newBook.imageUrl,
              'favorite': newBook.isFavorite,
              'active': newBook.active,
              'category': newBook.category.toJson(),
            }));
        _items[prodIndex] = newBook;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {
      print("problem with updating book");
    }
  }

  Future<void> fetchAndSetBooks() async {
    Uri url = Uri.parse(
        'http://192.168.1.56:8080/api/book');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(utf8.decode(response.bodyBytes))['data'] as List<dynamic>;
      final List<Book> loadProducts = [];
      for (var element in extractedData) {
        loadProducts.add(Book(
          id: element['id'],
          title: element['title'],
          description: element['description'],
          unitPrice: element['unitPrice'],
          author: element['author'],
          publicationDate: element['publicationDate'],
          imageUrl: element['imageUrl'],
          isFavorite: element['favorite'],
          category: Category(
            id: element['category']['id'],
            name: element['category']['name'],
          ),
          active: element['active'],
        ));
      }
      _items = loadProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> deleteBook(int id) async {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/books/$id');

    String message = '';
    try {
      final response = await http.delete(url);
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
