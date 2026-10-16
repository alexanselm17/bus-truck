import 'package:flutter/material.dart';

class LoginResetText extends StatelessWidget {
  final String? longText;
  final String? actionText;
  final VoidCallback press;
  final Color? actionColor;
  const LoginResetText(
      {Key? key,
      this.longText,
      this.actionText,
      required this.press,
      this.actionColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text(
          longText!,
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal),
        ),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          onTap: press,
          child: Text(
            actionText!,
            style: TextStyle(
                fontSize: 14.0, fontWeight: FontWeight.bold, color: actionColor),
          ),
        )
      ]),
    );
  }
}
