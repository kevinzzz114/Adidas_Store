import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Homepage.dart';

class CustomerListBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
            },
            child: Icon(Icons.arrow_back),
          ),
          Padding(padding: EdgeInsets.only(left: 20),
            child: Text(
              "Customer List",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
