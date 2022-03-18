import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/book.dart';
import '../models/category.dart';
import '../providers/book_provider.dart';
import '../providers/category_provider.dart';

class BookEditScreen extends StatefulWidget {
  static const routeName = '/book-edit';
  @override
  _BookEditScreen createState() => _BookEditScreen();
}

class _BookEditScreen extends State<BookEditScreen> {
  final _priceFocusNode = FocusNode();
  final _authorFocusNode = FocusNode();
  final _publicationDateFocusNode = FocusNode();
  final _publicationDateDateRangeController = DateRangePickerController();
  final _publicationDateTextController = TextEditingController();
  final _categoryFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Book _editedBook = Book(id: 0, title: '', description: '', unitPrice: 0, author: '', publicationDate: '', imageUrl: '', category: Category(id: 0, name: ''), active: true, isFavorite: false);
  var selectedCategoryId = '';
  bool _isInit = true;
  bool _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'unitPrice': '',
    'author': '',
    'publicationDate': '',
    'imageUrl': '',
    'category': {
      'id': '',
      'name': '',
    },
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() { _isLoading = true;});
      Provider.of<CategoryProvider>(context).fetchAndSetCategories().then((value) => setState(() { _isLoading = false; }));
      if (ModalRoute.of(context)!.settings.arguments != null) {
        var productId = ModalRoute.of(context)!.settings.arguments as int;
        if (productId != 0) {
          _editedBook = Provider.of<BookProvider>(context, listen: false).findById(productId);
          print(_editedBook.category);
          selectedCategoryId = _editedBook.category.id.toString();
          _imageUrlController.text = _editedBook.imageUrl;
          _initValues = {
            'title': _editedBook.title,
            'description': _editedBook.description,
            'unitPrice': _editedBook.unitPrice.toString(),
            'author': _editedBook.author,
            'publicationDate': _editedBook.publicationDate,
            'imageUrl': _editedBook.imageUrl,
            'category': {
              'id': _editedBook.category.id,
              'name': _editedBook.category.name,
            },
          };
          _publicationDateTextController.text = _editedBook.publicationDate;
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
    if (_editedBook.id != 0) {
      try {
        Provider.of<BookProvider>(context, listen: false).updateBook(_editedBook.id, _editedBook);
        Navigator.of(context).pop();
        setState(() {_isLoading = false;});
      }  catch (error) {
        await showDialog(context: context, builder: (ctx) => AlertDialog(
            title: const Text('Error'), content: Text(error.toString(),),
            actions: <Widget>[TextButton(onPressed: () => {Navigator.of(ctx).pop(), setState(() {_isLoading = false;}),}, child: const Text('Okay'))]
        ));
      }
    } else {
      try {
        await Provider.of<BookProvider>(context, listen: false).addBook(_editedBook);
        Navigator.of(context).pop();
        setState(() {_isLoading = false;});
      } catch (error) {
        await showDialog(context: context, builder: (ctx) => AlertDialog(
            title: const Text('Error'), content: Text(error.toString(),),
            actions: <Widget>[TextButton(onPressed: () => {Navigator.of(ctx).pop(), setState(() {_isLoading = false;}),}, child: const Text('Okay'))]
        ));
      }
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 300,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            initialSelectedDate: _initValues['publicationDate'] == '' ? DateTime.now() : DateTime.parse(_initValues['publicationDate'].toString()),
            todayHighlightColor: Colors.blue,
            controller: _publicationDateDateRangeController,
            onSelectionChanged: (date) {
              setState(() {
                _publicationDateTextController.text = _editedBook.publicationDate = DateFormat('yyyy-MM-dd').format(date.value);
              });
              Navigator.of(context).pop();
            },
          ),
        )
    ).then((value) => setState(() {
      if (_publicationDateTextController.text == '') {
        _publicationDateTextController.text = _editedBook.publicationDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
      _isLoading = false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context).items;
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (var category in categories) {
      dropDownItems.add(DropdownMenuItem(
        child: Text(category.name),
        value: category.id.toString(),
      ));
    }
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
              initialValue: _initValues['title'].toString() == '' ? _editedBook.title : _initValues['title'].toString(),
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
              onSaved: (value) => _editedBook.setTitle(value!),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập dữ liệu.';
                }
                return null;
              },
            ),
            TextFormField(decoration: const InputDecoration(labelText: 'Giá tiền'), focusNode: _priceFocusNode, textInputAction: TextInputAction.next, keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
              initialValue: _initValues['unitPrice'].toString(),
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_authorFocusNode),
              onSaved: (value) => _editedBook.setUnitPrice(int.parse(value!)),
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
            TextFormField(decoration: const InputDecoration(labelText: 'Tác giả'), focusNode: _authorFocusNode, textInputAction: TextInputAction.next,
              initialValue: _initValues['author'].toString(),
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
              onSaved: (value) => _editedBook.setAuthor(value!),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập tác giả.';
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () => _showDatePicker(context),
              child: const Text('Chọn ngày xuất bản'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ngày xuất bản'),
              textInputAction: TextInputAction.next,
              controller: _publicationDateTextController,
              readOnly: true,
              enabled: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập ngày xuất bản.';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Danh mục'),
              isExpanded: true,
              hint: const Text('Chọn danh mục'),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey,),
              focusNode: _categoryFocusNode,
              iconSize: 20,
              items: dropDownItems,
              onChanged: (value) => setState(() {
                selectedCategoryId = value.toString();
                _descriptionFocusNode.requestFocus();
              }),
              value: selectedCategoryId == '' ? null : selectedCategoryId,
              validator: (value) {
                if (value == null) {
                  return 'Hãy chọn danh mục.';
                }
                return null;
              },
              onSaved: (value) => _editedBook.setCategory(categories.firstWhere((category) => category.id == int.parse(value.toString()))),
            ),
            TextFormField(decoration: const InputDecoration(labelText: 'Mô tả'), focusNode: _descriptionFocusNode, keyboardType: TextInputType.multiline, maxLines: 4,
              textInputAction: TextInputAction.next, onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_imageFocusNode),
              initialValue: _initValues['description'].toString(),
              onSaved: (value) => _editedBook.setDescription(value!),
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
                    onSaved: (value) => _editedBook.setImageUrl(value!),
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