import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  Map toJson() => {
    'id': id,
    'name': name,
  };
}