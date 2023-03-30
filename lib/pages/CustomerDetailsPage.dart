import 'package:flutter/material.dart';

import '../dataFetcher.dart';
import '../models/Customer.dart';
import '../widgets/HomeAppBar.dart';
import '../widgets/ProductDetailsNavBar.dart';


class CustomerDetailsPage extends StatefulWidget {
  final Customer user;

  CustomerDetailsPage({required this.user});

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  late String _userName;
  late String _userEmail;
  late bool submitResponse;

  Future<void> _submitData() async {
    try {
      if (widget.user != null && widget.user.id != null) {
        var response = await DataFetcher.submitEditUserForm(
            widget.user.id, _userName, _userEmail);
        setState(() {
           submitResponse = response;
        });
        print(response);
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
    if (widget.user != null) {
      _userName = widget.user.name;
      _userEmail = widget.user.email;
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
                initialValue:
                widget.user != null ? _userEmail.toString() : "-",
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userEmail = value.toString();
                },
              ),
              TextFormField(
                initialValue:
                widget.user != null ? _userName.toString() : "-",
                decoration: InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userName = value.toString();
                },
              ),
             
              ElevatedButton(
                child: Text('Save Changes'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    _submitData();
                    // Do something with the product data, such as
                    // adding it to a database or displaying it on
                    // a confirmation page.
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
