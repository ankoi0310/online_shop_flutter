import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/category.dart';

class Book with ChangeNotifier {
  int id;
  String title;
  String description;
  int unitPrice;
  String author;
  String publicationDate;
  String imageUrl;
  bool isFavorite;
  Category category;
  bool active;

  Book({required this.id, required this.title, required this.description, required this.unitPrice, required this.author,
    required this.publicationDate, required this.imageUrl, required this.isFavorite, required this.category, required this.active});

  // getter & setter
  int get getId => id;
  String get getTitle => title;
  String get getDescription => description;
  int get getUnitPrice => unitPrice;
  String get getAuthor => author;
  String get getPublicationDate => publicationDate;
  String get getImageUrl => imageUrl;
  bool get getIsFavorite => isFavorite;
  Category get getCategory => category;
  bool get getActive => active;

  // setter
  void setId(int id) {
    this.id = id;
    notifyListeners();
  }
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }
  void setDescription(String description) {
    this.description = description;
    notifyListeners();
  }
  void setUnitPrice(int unitPrice) {
    this.unitPrice = unitPrice;
    notifyListeners();
  }
  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }
  void setPublicationDate(String publicationDate) {
    this.publicationDate = publicationDate;
    notifyListeners();
  }
  void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
    notifyListeners();
  }
  void setIsFavorite(bool isFavorite) {
    this.isFavorite = isFavorite;
    notifyListeners();
  }
  void setCategory(Category category) {
    this.category = category;
    notifyListeners();
  }
  void setActive(bool active) {
    this.active = active;
    notifyListeners();
  }

  Map toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'unitPrice': unitPrice,
    'author': author,
    'publicationDate': publicationDate,
    'imageUrl': imageUrl,
    'favorite': isFavorite,
    'category': category.toJson(),
    'active': active
  };

  Future<void> toggleFavoriteStatus() {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/book');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return http.put(url, headers: headers, body: json.encode({
      'id': id,
      'title': title,
      'description': description,
      'unitPrice': unitPrice,
      'author': author,
      'publicationDate': publicationDate,
      'imageUrl': imageUrl,
      'favorite': !isFavorite,
      'active': active,
      'category': category.toJson()
    })).then((response) {
      if (response.statusCode == 200) {
        isFavorite = !isFavorite;
        notifyListeners();
      } else {
        try {
          print(json.decode(response.body));
        } on FormatException catch (_) {
          print('Message return is not a valid JSON format');
        }
      }
    }).catchError((error) => throw error);
  }
}
