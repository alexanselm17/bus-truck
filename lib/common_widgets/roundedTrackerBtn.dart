import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RoundedTrackerBtn extends StatelessWidget {
  final String? text;
  final VoidCallback press;
  final Color? color, textColor;
  const RoundedTrackerBtn({
    Key? key,
    this.text,
    required this.press,
    this.color = AppConstants.primaryOrange,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width,
        height: 50.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29.0),
          child: TextButton(
              style: TextButton.styleFrom(backgroundColor: color),
              child: Text(
                text!.toUpperCase(),
                style: TextStyle(color: textColor),
              ),
              onPressed: press),
        ),
      ),
    );
  }
}
