import 'package:flutter/material.dart';

class ProductEditScreen extends StatefulWidget {
  static const routeName = '/product-edit';
  @override
  _ProductEditScreen createState() => _ProductEditScreen();
}

class _ProductEditScreen extends State<ProductEditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(child: SingleChildScrollView(child: Column(
          children: <Widget>[
            TextField(decoration: InputDecoration(labelText: 'Title'), textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),),
            TextField(decoration: InputDecoration(labelText: 'Price'), focusNode: _priceFocusNode, textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true), onSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),),
            TextField(decoration: InputDecoration(labelText: 'Description'), focusNode: _descriptionFocusNode, keyboardType: TextInputType.multiline, maxLines: 4,
              textInputAction: TextInputAction.next, onSubmitted: (_) => FocusScope.of(context).requestFocus(_imageFocusNode),),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8, left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: _imageUrlController.text.isEmpty ? Text('Enter an URL') : Image.network(_imageUrlController.text),
                ),
                Expanded(
                  child: TextField(decoration: InputDecoration(labelText: 'Image URL'), focusNode: _imageFocusNode,
                    controller: _imageUrlController, keyboardType: TextInputType.url, textInputAction: TextInputAction.done,
                    onEditingComplete: () => setState(() {}),),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            RaisedButton(
              child: const Text('Save'),
              onPressed: () {},
            )
          ],
        ),),),
      ),
    );
  }
}