import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products_provider.dart';

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
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(id: 0, name: '', description: '', unitPrice: 0, imageUrl: '',);
  bool _isInit = true;
  bool _isLoading = false;

  var _initValues = {
    'name': '',
    'description': '',
    'unitPrice': '',
    'imageUrl': '',
  };

  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        var productId = ModalRoute.of(context)!.settings.arguments as int;
        if (productId != 0) {
          _editedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
          _imageUrlController.text = _editedProduct.imageUrl;
          _initValues = {
            'name': _editedProduct.name,
            'description': _editedProduct.description,
            'unitPrice': _editedProduct.unitPrice.toString(),
            'imageUrl': '',
          };
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    setState(() {_isLoading = true;});
    _form.currentState?.save();
    if (_editedProduct.id !=0) {
      Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
      setState(() {_isLoading = false;});
    } else {
      try {
        try {
          await Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
          Navigator.of(context).pop();
          setState(() {_isLoading = false;});
        } catch (error) {
          await showDialog(context: context, builder: (ctx) => AlertDialog(
              title: Text('Error'), content: Text(error.toString(),),
              actions: <Widget>[FlatButton(onPressed: () => {Navigator.of(ctx).pop(), setState(() {_isLoading = false;}),}, child: Text('Okay'))]
          ));
        }
      } catch (error) {
        await showDialog(context: context, builder: (ctx) => AlertDialog(
            title: Text('Error'), content: Text(error.toString(),),
            actions: <Widget>[FlatButton(onPressed: () => {Navigator.of(ctx).pop(), setState(() {_isLoading = false;}),}, child: Text('Okay'))]
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(key: _form, child: SingleChildScrollView(child: Column(
          children: <Widget>[
            TextFormField(decoration: InputDecoration(labelText: 'Title'), textInputAction: TextInputAction.next,
              initialValue: _initValues['name'],
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
              onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: value!, description: _editedProduct.description, unitPrice: _editedProduct.unitPrice, imageUrl: _editedProduct.imageUrl,),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
            ),
            TextFormField(decoration: InputDecoration(labelText: 'Price'), focusNode: _priceFocusNode, textInputAction: TextInputAction.next, keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              initialValue: _initValues['unitPrice'],
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
              onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: _editedProduct.name, description: _editedProduct.description, unitPrice: double.parse(value!), imageUrl: _editedProduct.imageUrl,),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a price.';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than zero.';
                }
                return null;
              },
            ),
            TextFormField(decoration: InputDecoration(labelText: 'Description'), focusNode: _descriptionFocusNode, keyboardType: TextInputType.multiline, maxLines: 4,
              textInputAction: TextInputAction.next, onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_imageFocusNode),
              initialValue: _initValues['description'],
              onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: _editedProduct.name, description: value!, unitPrice: _editedProduct.unitPrice, imageUrl: _editedProduct.imageUrl,),
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8, left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: _imageUrlController.text.isEmpty ? Text('Enter an URL') : FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.cover,),
                ),
                Expanded(
                  child: TextFormField(decoration: InputDecoration(labelText: 'Image URL'), focusNode: _imageFocusNode,
                    controller: _imageUrlController, keyboardType: TextInputType.url, textInputAction: TextInputAction.done,
                    onEditingComplete: () => setState(() {}),
                    onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: _editedProduct.name, description: _editedProduct.description, unitPrice: _editedProduct.unitPrice, imageUrl: value!,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an image URL.';
                      }
                      if (!value.startsWith('http') && !value.startsWith('https')) {
                        return 'Please enter a valid URL.';
                      }
                      if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                        return 'Please enter a valid image URL.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),),),
      ),
    );
  }

  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }
}