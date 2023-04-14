import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataFetcher.dart';
import '../global.dart';
import '../widgets/CategoriesWidget.dart';
import '../widgets/HomeAppBar.dart';
import '../widgets/ItemsWidget.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class HomePage extends StatefulWidget {
  // Locale? locale = const Locale("en", "US");
  // HomePage({locale});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _itemsData = []; // List to store items data
  List< dynamic> _usersData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalData globalData = GlobalData();
  Locale _locale = const Locale('en', 'US');

  int _counter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Add any code here that should be run every time the widget is rebuilt
    _counter++; // Increment the counter every time the widget is rebuilt
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Call fetchData method when widget is initialized
    // _fetchUserData();
  }

  @override
  void didPopNext() {
    _fetchData(); // Reload data when a page is popped
    // _fetchUserData();
  }

  @override
  void didPush() {
    _fetchData(); // Reload data when a page is pushed
    // _fetchUserData();
  }

  void _fetchData() async {
    List<Map<String, dynamic>> data = await DataFetcher.fetchData();
    setState(() {
      _itemsData = data; // Set items data to state
      print(data);
    });
  }

  // void _fetchUserData() async {
  //   List< dynamic> data = await DataFetcher.fetchUsersData();
  //   setState(() {
  //     _usersData = data; // Set users data to state
  //     print(data);
  //   });
  // }

  // Function to open the camera
  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Use the picked image file for further processing
      File imageFile = File(pickedFile.path);

      // Get the directory where you want to save the image
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String directoryPath = appDirectory.path;

      // Generate a unique filename for the image by appending current timestamp
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = 'image_$timestamp.jpg';

      // Create a File object with the new file path
      File newImageFile = File('$directoryPath/$fileName');

      // Copy the image file to the new file path
      await imageFile.copy(newImageFile.path);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Image saved successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle error if image picking fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to open camera.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Semantics(
        label: "Home Page",
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF4C53A5),
                  ),
                  child: Text(''),
                ),
                if (globalData.userRole == "admin")
                  ListTile(
                    title: const Text('Customers'),
                    onTap: () {
                      Navigator.pushNamed(context, 'customerListPage');
                    },
                  ),
                if (globalData.userRole == "admin")
                  ListTile(
                    title: const Text('Add Product'),
                    onTap: () {
                      Navigator.pushNamed(context, 'productDetailsPage');
                    },
                  ),
                if (globalData.userRole == "admin")
                  ListTile(
                    title: const Text('Sales Report'),
                    onTap: () {
                      Navigator.pushNamed(context, 'reportPage');
                    },
                  ),
                if (globalData.userRole != "")
                  ListTile(
                    title: const Text('Log Out'),
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                      globalData.userRole = "";
                    },
                  ),
                if (globalData.userRole == "")
                  ListTile(
                    title: const Text('Log In'),
                    onTap: () {
                      Navigator.pushNamed(context, 'loginPage');
                      globalData.userRole = "";
                    },
                  ),
                if (globalData.userRole == "customer")
                  ListTile(
                    title: const Text('Edit Profile'),
                    onTap: () {
                      Navigator.pushNamed(context, 'customerEditProfilePage');
                    },
                  )
                ],
            ),
          ),
          body: ListView(
            children: [
              HomeAppBar(scaffoldKey: _scaffoldKey),
              Container(
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    color: Color(0xFFEDECF2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    )),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          height: 50,
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Here..."),
                          ),
                        ),
                        Spacer(),
                        if (globalData.userRole == "admin")
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 27,
                            color: Color(0xFF4C53A5),
                          ),
                          onPressed: () {
                            _openCamera(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5)),
                    ),
                  ),
                  CategoriesWidget(),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(
                      "Products",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5)),
                    ),
                  ),
                  _itemsData != null || _itemsData != []
                      ? ItemsWidget(itemList: _itemsData)
                      : Center(child: CircularProgressIndicator())
                ]),
              )
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
        ));
  }
}
