import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/CartAppBar.dart';
import 'package:flutter_application_1/widgets/CartItemSamples.dart';

import '../widgets/CartBottomNavBar.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CartAppBar(),
          Container(
            height: 700,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            ),
            child: Column(children: [
              CartItemSamples(),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10)
              //   ),
              // )
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF4C53A5)
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Add Coupun Code",
                    style: TextStyle(
                      color: Color(0xFF4C53A5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  )
                ]),
              )
            ]),
          )
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(),
    );
  }
}
//     )
//       body: ListView(
//         children: [
//           HomeAppBar(),
//           Container(
//             // height: 500,
//             padding: EdgeInsets.only(top: 15),
//             decoration: BoxDecoration(
//                 color: Color(0xFFEDECF2),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(35),
//                   topRight: Radius.circular(35),
//                 )),
//             child: Column(children: [
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 15),
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(left: 5),
//                       height: 50,
//                       width: 300,
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Search Here..."),
//                       ),
//                     ),
//                     Spacer(),
//                     Icon(
//                       Icons.camera_alt,
//                       size: 27,
//                       color: Color(0xFF4C53A5),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                 child: Text(
//                   "Categories",
//                   style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF4C53A5)),
//                 ),
//               ),
//               CategoriesWidget(),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                 child: Text(
//                   "Best Selling",
//                   style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF4C53A5)),
//                 ),
//               ),
//               ItemsWidget()
//             ]),
//           )
//         ],
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//           backgroundColor: Colors.transparent,
//           onTap: (index){},
//           height: 70,
//           color: Color(0xFF4C53A5),
//           items: [
//             Icon(
//               Icons.home,
//               size: 30,
//               color: Colors.white,
//             ),
//             Icon(
//               CupertinoIcons.cart_fill,
//               size: 30,
//               color: Colors.white,
//             ),
//             Icon(
//               Icons.list,
//               size: 30,
//               color: Colors.white,
//             ),
//           ]),
//     );
//   }
// }
