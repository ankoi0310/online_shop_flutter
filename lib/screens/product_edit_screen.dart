import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

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

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
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
              title: const Text('Error'), content: Text(error.toString(),),
              actions: <Widget>[TextButton(onPressed: () => {Navigator.of(ctx).pop(), setState(() {_isLoading = false;}),}, child: const Text('Okay'))]
          ));
        }
      } catch (error) {
        await showDialog(context: context, builder: (ctx) => AlertDialog(
            title: const Text('Error'), content: Text(error.toString(),),
            actions: <Widget>[TextButton(onPressed: () => {Navigator.of(ctx).pop(), setState(() {_isLoading = false;}),}, child: const Text('Okay'))]
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa sản phẩm'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(key: _form, child: SingleChildScrollView(child: Column(
          children: <Widget>[
            TextFormField(decoration: const InputDecoration(labelText: 'Tựa đề'), textInputAction: TextInputAction.next,
              initialValue: _initValues['name'],
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
              onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: value!, description: _editedProduct.description, unitPrice: _editedProduct.unitPrice, imageUrl: _editedProduct.imageUrl,),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập dữ liệu.';
                }
                return null;
              },
            ),
            TextFormField(decoration: const InputDecoration(labelText: 'Giá tiền'), focusNode: _priceFocusNode, textInputAction: TextInputAction.next, keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
              initialValue: _initValues['unitPrice'],
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
              onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: _editedProduct.name, description: _editedProduct.description, unitPrice: int.parse(value!), imageUrl: _editedProduct.imageUrl,),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập giá.';
                }
                if (int.tryParse(value) == null) {
                  return 'Hãy nhập giá hợp lệ.';
                }
                if (int.parse(value) <= 0) {
                  return 'Hãy nhập số lớn hơn 0.';
                }
                return null;
              },
            ),
            TextFormField(decoration: const InputDecoration(labelText: 'Mô tả'), focusNode: _descriptionFocusNode, keyboardType: TextInputType.multiline, maxLines: 4,
              textInputAction: TextInputAction.next, onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_imageFocusNode),
              initialValue: _initValues['description'],
              onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: _editedProduct.name, description: value!, unitPrice: _editedProduct.unitPrice, imageUrl: _editedProduct.imageUrl,),
            ),
            Row(
              children: [
                Container(width: 100, height: 100, margin: const EdgeInsets.only(top: 8, left: 5),
                  child: _imageUrlController.text.isEmpty ? const Text('Nhập đường dẫn hình ảnh') : FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.cover,),
                ),
                Expanded(
                  child: TextFormField(decoration: const InputDecoration(labelText: 'Đường dẫn hình ảnh'), focusNode: _imageFocusNode,
                    controller: _imageUrlController, keyboardType: TextInputType.url, textInputAction: TextInputAction.done,
                    onEditingComplete: () => setState(() {}),
                    onSaved: (value) => _editedProduct = Product(id: _editedProduct.id, name: _editedProduct.name, description: _editedProduct.description, unitPrice: _editedProduct.unitPrice, imageUrl: value!,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Hãy nhập đường dẫn hình ảnh.';
                      }
                      if (!value.startsWith('http') && !value.startsWith('https')) {
                        return 'Vui lòng nhập đường dẫn hợp lệ.';
                      }
                      if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                        return 'Vui lòng nhập ảnh hợp lệ.';
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

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }
}