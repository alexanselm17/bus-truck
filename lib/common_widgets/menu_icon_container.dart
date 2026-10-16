import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MenuIconContainer extends StatelessWidget {
  const MenuIconContainer({
    Key? key,
    @required this.scaffoldkey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldkey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        scaffoldkey!.currentState!.openDrawer();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.menu,
            color: AppConstants.colorPrimary,
          ),
        ),
      ),
    );
  }
}
