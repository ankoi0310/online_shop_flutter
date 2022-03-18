import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../providers/book_provider.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    Book loadedBook = Provider.of<BookProvider>(context, listen: false).findById(id);
    DateTime publicationDate = DateTime.parse(loadedBook.publicationDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedBook.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: Image.network(loadedBook.imageUrl, fit: BoxFit.cover,),),
            const SizedBox(height: 10,),
            Text(loadedBook.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text('Tác giả: ', style: TextStyle(fontSize: 16),),
                  Text(loadedBook.author, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const Text('Ngày xuất bản: ', style: TextStyle(fontSize: 16),),
                  Text(DateFormat('dd-MM-yyyy').format(publicationDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  const Text('Thể loại: ', style: TextStyle(fontSize: 16),),
                  Text(loadedBook.category.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  const Text('Giá bán: ', style: TextStyle(fontSize: 16),),
                  Text('${loadedBook.unitPrice}'.toVND(unit: 'VNĐ'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: Text(loadedBook.description, style: const TextStyle(fontSize: 18),),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ]
        ),
      ),
    );
  }
  
}