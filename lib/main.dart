import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/ReportPage.dart';
import 'package:flutter_application_1/pages/SignupPage.dart';
import '../pages/ProductDetailsPage.dart';
import '../pages/CustomerListPage.dart';
import '../pages/LoginPage.dart';
import '../pages/CartPage.dart';
import 'pages/Homepage.dart';
import 'pages/ItemPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(MyApp());
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('id', 'ID');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Adidas App',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        navigatorObservers: [routeObserver],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(),
        routes: {
          "cartPage": (context) => CartPage(),
          "loginPage": (context) => LoginPage(),
          "homePage": (context) => HomePage(),
          "itemPage": (context) => ItemPage(),
          "productDetailsPage": (context) => ProductDetailsPage(),
          "customerListPage": (context) => CustomerListPage(),
          "reportPage": (context) => ReportPage(),
          "signupPage": (context) => SignupPage()
        });
  }
}
