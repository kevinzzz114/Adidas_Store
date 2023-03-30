import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  HomeAppBar({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _HomeAppBarState extends State<HomeAppBar> {
  String shopTitle = "Adidas Shop";
  Locale _locale = const Locale('en', 'US');

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              widget.scaffoldKey?.currentState?.openDrawer();
            },
            child: Icon(
              Icons.sort_outlined,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              // AppLocalizations.of(context)!.title,
              shopTitle,
              // "shop",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          Spacer(),
          DropdownButton<Locale>(
            value: _locale,
            onChanged: (value) {
              AppLocalizations.delegate
                  .load(value!)
                  .then((value) => setState(() {
                        shopTitle = value.title as String;
                        print(shopTitle);
                      }));
              _locale = value;
            },
            items: [
              DropdownMenuItem(
                value: const Locale('en', 'US'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: const Locale('id', 'ID'),
                child: Text('Malay'),
              ),
            ],
          ),
          Spacer(),
          badges.Badge(
            badgeContent: Padding(
                padding: EdgeInsets.all(7),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "cartPage");
                  },
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 32,
                    color: Color(0xFF4C53A5),
                  ),
                )
                // child: Text("3", style: TextStyle(color: Colors.white),),
                ),
          )
        ],
      ),
    );
  }
}
