import 'dart:convert';
import 'package:http/http.dart' as http_client;
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  int id;
  String name;
  String description;
  int unitPrice;
  String imageUrl;
  bool isFavorite;

  Product({required this.id, required this.name, required this.description, required this.unitPrice,
    required this.imageUrl, this.isFavorite = false });

  Map toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'unitPrice': unitPrice,
    'imageUrl': imageUrl,
    'isFavorite': isFavorite,
  };

  Future<void> toggleFavoriteStatus() {
    Uri url = Uri.parse('http://192.168.1.56:8080/api/products/$id');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return http_client.put(url, headers: headers, body: json.encode({
      'name': name,
      'description': description,
      'unitPrice': unitPrice,
      'imageUrl': imageUrl,
      'favorite': !isFavorite,
      'unitsInStock': 100,
      'active': true,
      'category': {"id": 5, "categoryName": "MobileProduct"}
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
