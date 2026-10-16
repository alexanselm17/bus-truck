import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool showText;

  Loading({this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(height: 10),
        showText ? Text("Please wait") : Text(''),
      ],
    );
  }
}
