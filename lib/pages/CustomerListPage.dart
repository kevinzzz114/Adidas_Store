import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dataFetcher.dart';
import '../models/Customer.dart';
import '../widgets/CustomerListBar.dart';
import '../widgets/HomeAppBar.dart';
import 'package:http/http.dart' as http;

import 'CustomerDetailsPage.dart';
import 'ProductDetailsPage.dart';


class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Customer> _customers = [];

  void _fetchData() async {
    List<dynamic> data = await DataFetcher.fetchUsersData();
    setState(() {
      _customers = data
          .map((item) => Customer(
              id: item['id'], name: item['name'], email: item['email']))
          .toList(); // Set items data to state
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CustomerListBar(),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _customers.length,
            itemBuilder: (BuildContext context, int index) {
              final customer = _customers[index];
              return Card(
                child: ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerDetailsPage(user: customer),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final response = await http.delete(
                            Uri.parse(
                                '${DataFetcher.databaseUrl}/fetch_data.php'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'customer_id': customer.id, 'action': 'customer'}),
                          );

                          if (response.statusCode == 200) {
                            setState(() {
                              _customers.remove(customer);
                            });
                          } else {
                            // display an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error deleting customer.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          onTap: (index) {},
          height: 70,
          color: Color(0xFF4C53A5),
          items: [
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              CupertinoIcons.cart_fill,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.list,
              size: 30,
              color: Colors.white,
            ),
          ]),
    );
  }
}
