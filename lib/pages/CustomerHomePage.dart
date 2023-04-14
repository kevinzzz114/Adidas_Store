import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/customerEditProfile.dart';
import '../dataFetcher.dart';
import '../global.dart';
import '../widgets/CategoriesWidget.dart';
import '../widgets/HomeAppBar.dart';
import '../widgets/ItemsWidget.dart';
import 'LoginPage.dart';
import 'package:flutter_application_1/models/User.dart';
import 'package:flutter_application_1/models/Customer.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerHomePage extends StatefulWidget {
  // Locale? locale = const Locale("en", "US");
  // HomePage({locale});

  final LoginData loginData; // Update the parameter type
  CustomerHomePage({required this.loginData, Key? key}) : super(key: key);

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
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
    _fetchLoginUser();

    // _fetchUserData();
    // String email = widget.loginData.email; // Retrieve email from loginData
    // String password = widget.loginData.password; // Retrieve password from loginData
    // // Use email and password variables as needed
    // print('Email: $email');
    // print('Password: $password');
  }

  @override
  void didPopNext() {
    _fetchData(); // Reload data when a page is popped
    _fetchLoginUser();
    // _fetchUserData();
  }

  @override
  void didPush() {
    _fetchData(); // Reload data when a page is pushed
    _fetchLoginUser();
    // _fetchUserData();
  }

  void _fetchData() async {
    List<Map<String, dynamic>> data = await DataFetcher.fetchData();
    setState(() {
      _itemsData = data; // Set items data to state
      print(data);
    });
  }

  String userName = '';
  int userID = 0;
  String userEmail = '';
  String userRole = '';
  String userPassword = '';


  Future<void> _fetchLoginUser() async {
    String email = widget.loginData.email; // Retrieve email from loginData
    String password = widget.loginData.password; // Retrieve password from loginData

    // Use email and password variables as needed
    print('Email: $email');
    print('Password: $password');

    // Check if email is not null or empty before fetching user data
    if (email != null && email.isNotEmpty) {
      try {
        // Assuming you have a User model class to represent the user data
        User user = await DataFetcher.fetchUserData(email);

        // Step 2: Update the userName variable with user's name
        setState(() {
          userName = user.name;
          userID = user.id;
          userEmail = user.email;
          userRole = user.role;
          userPassword = user.password;
          print('User: $user');
        });

      } catch (error) {
        print('Failed to fetch user data: $error');
      }
    } else {
      print('Email is null or empty. Cannot fetch user data.');
    }
  }


  // void _fetchUserData() async {
  //   List< dynamic> data = await DataFetcher.fetchUsersData();
  //   setState(() {
  //     _usersData = data; // Set users data to state
  //     print(data);
  //   });
  // }

  Widget build(BuildContext context) {
    // final user =
    // ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    //
    return Semantics(
        label: "Home Page",
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Welcome $userName'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerEditProfilePage(
                            userName: userName,
                            userID: userID,
                            userEmail: userEmail,
                            userPassword: userPassword,
                          ),
                        ),
                      );
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
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Here..."),
                          ),
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
