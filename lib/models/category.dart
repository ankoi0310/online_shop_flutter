import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final int id;
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