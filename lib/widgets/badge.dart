import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Widget child;
  String value;
  Color? color;


  Badge({Key? key, required this.child, required this.value, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            child: Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: color),
            constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
          ),
        )
      ],
    );
  }
  
}