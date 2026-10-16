import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final double barHeight = 66.0;

  const MyAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(""),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'School Bus Track',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
