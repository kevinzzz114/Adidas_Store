import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../dataFetcher.dart';
import '../widgets/HomeAppBar.dart';
import '../widgets/ProductDetailsNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:file_picker/file_picker.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  ProductDetailsPage({this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  late String _productName;
  late String _description;
  late double _weight;
  late double _unitPrice;
  late int _stockQuantity;
  late bool submitResponse;
  String newFilePath = "";

  List<String> _images = [];
  List<Map<String, dynamic>> _itemsData = [];
  late File _image = File('');

  Future<void> _uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${DataFetcher.databaseUrl}/image_upload.php'));
    request.files.add(await http.MultipartFile.fromPath('image', newFilePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Error uploading image: ${response.statusCode}');
    }
  }

  Future<void> _submitData() async {
    try {
      if (widget.product != null && widget.product!['id'] != null) {
        var response = await DataFetcher.submitEditProductForm(
            widget.product!['id'],
            _productName,
            _description,
            _weight,
            _unitPrice,
            _stockQuantity,
            newFilePath
            );
        // }
        setState(() {
          submitResponse = response as bool;
        });
        print(response);
        // _itemsData = DataFetcher.fetchData() as List<Map<String, dynamic>>;
      } else {
//If product does not exist, submit an add product request
        var response = await DataFetcher.submitAddProductForm(_productName,
            _description, _weight, _unitPrice, _stockQuantity, newFilePath);
        setState(() {
          submitResponse = response;
        });
        // _itemsData = DataFetcher.fetchData() as List<Map<String, dynamic>>;
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // If a product is passed in, pre-populate the form fields
    if (widget.product != null) {
      _productName = widget.product!['name'];
      _description = widget.product!['description'];
      _weight = double.parse(widget.product!['weight']);
      _unitPrice = double.parse(widget.product!['unit_price']);
      _stockQuantity = int.parse(widget.product!['quantity']);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);

      final localFilePath = '${appDir.path}/$fileName';
      _image = File(localFilePath);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = '$timestamp-$fileName';
      newFilePath = '${appDir.path}/$newFileName';

      _image.copy(newFilePath);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ProductDetailsNavBar(),
              TextFormField(
                initialValue: widget.product != null ? _productName : "-",
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productName = value ?? "";
                },
              ),
              TextFormField(
                initialValue: widget.product != null ? _description : "-",
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? "";
                },
              ),
              TextFormField(
                initialValue: widget.product != null ? _weight.toString() : "0",
                decoration: InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.parse(value ?? 0.toString());
                },
              ),
              TextFormField(
                initialValue:
                    widget.product != null ? _unitPrice.toString() : "0",
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _unitPrice = double.parse(value ?? 0.toString());
                },
              ),
              TextFormField(
                initialValue:
                    widget.product != null ? _stockQuantity.toString() : "0",
                decoration: InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a stock quantity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _stockQuantity = int.parse(value ?? 0.toString());
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Add Image'),
                onTap: _pickImage,
              ),
              Visibility(
                visible: newFilePath != "",
                child: Column(
                  children: [Image.file(File(newFilePath))],
                ),
              ),
              ElevatedButton(
                child: Text('Save Product'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    _submitData();
                    _uploadImage(_image);
                  }
                },
              ),
              ElevatedButton(
                child: Text('Delete Product'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (widget.product!['id'] != null) {
                      final response = await http.delete(
                        Uri.parse('${DataFetcher.databaseUrl}/fetch_data.php'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'product_id': widget.product!['id'],
                          'action': 'product'
                        }),
                      );

                      if (response.statusCode == 200) {
                        setState(() {});
                      } else {
                        // display an error message to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting customer.')),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
