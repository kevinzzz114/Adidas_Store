import 'package:flutter/material.dart';
import 'package:flutter_application_1/dataFetcher.dart';

import '../global.dart';

class ItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> itemList;
  GlobalData globalData = GlobalData();
  ItemsWidget({required this.itemList});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.68,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < itemList.length; i++)
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Color(0xFF4C53A5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "-50%",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  if (globalData.userRole == ""){
                    Navigator.pushNamed(context, "loginPage");
                  } else{
                    Navigator.pushNamed(context, "itemPage",
                      arguments: itemList[i]);
                  }
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Image.network(
                      '${DataFetcher.databaseUrl}/uploads/${itemList[i]['image']}', // replace with your image URL
                      width: 120, // set the width and height of the image
                      height: 120,
                      fit: BoxFit
                          .cover, // adjust the image to fit the size of the container
                    )),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  itemList[i]['name'] ?? "",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF4C53A5),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  itemList[i]['description'] ?? "",
                  style: TextStyle(fontSize: 15, color: Color(0xFF4C54A5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${itemList[i]['unit_price']}" ?? "",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C54A5)),
                      ),
                      Icon(
                        Icons.shopping_cart_checkout,
                        color: Color(0xFF4C54A5),
                      )
                    ]),
              )
            ]),
          )
      ],
    );
  }
}
