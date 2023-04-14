import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CustomerHomePage.dart';

import '../dataFetcher.dart';
import '../models/Customer.dart';
import '../widgets/HomeAppBar.dart';
import '../widgets/ProductDetailsNavBar.dart';
import '../widgets/CustomerDetailsNavBar.dart';
import 'package:flutter_application_1/pages/LoginPage.dart';


class CustomerEditProfilePage extends StatefulWidget {
  final String userName;
  final int userID;
  final String userEmail;
  final String userPassword;

  CustomerEditProfilePage({
    required this.userName,
    required this.userID,
    required this.userEmail,
    required this.userPassword});


  @override
  _CustomerEditProfilePageState createState() => _CustomerEditProfilePageState();
}

class _CustomerEditProfilePageState extends State<CustomerEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late int _userID= 0;
  late String _userName= '';
  late String _userEmail= '';
  late String _userPassword= '';
  late bool submitResponse = false;

  Future<void> _submitData() async {
    try {
      if (widget.userID != null) {
        var response = await DataFetcher.customerEditProfile(
            _userID, _userName, _userEmail, _userPassword);
        setState(() {
          submitResponse = response as bool;
        });
        print(response);
        // _itemsData = DataFetcher.fetchData() as List<Map<String, dynamic>>;
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to edit user'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userID != null) {
      _userID = widget.userID;
    }if (widget.userName != null) {
      _userName = widget.userName;
    }
    if (widget.userEmail != null) {
      _userEmail = widget.userEmail;
    }
    if (widget.userPassword != null) {
      _userPassword = widget.userPassword;
    }

  }

  @override
  Widget build(BuildContext context) {

    LoginData loginData = LoginData(email: _userEmail, password: _userPassword);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(25),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerHomePage(loginData: loginData),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C53A5)),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              TextFormField(
                initialValue:
                _userEmail ?? "",
                decoration: InputDecoration(labelText: 'Edit Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userEmail = value ?? "";
                },
              ),
              TextFormField(
                initialValue:
                _userPassword ?? "",
                decoration: InputDecoration(labelText: 'Edit Password'),
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userPassword = value ?? "";
                },
              ),
              TextFormField(
                initialValue:
                _userName ?? "",
                decoration: InputDecoration(labelText: 'Edit Name'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userName = value ?? "";
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
                  }else showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to edit user'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      });
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

