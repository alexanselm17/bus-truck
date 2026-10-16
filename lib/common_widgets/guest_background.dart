import 'package:flutter/material.dart';

class BackgroundPage extends StatelessWidget {
  final Widget? child;
  const BackgroundPage({
    Key? key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.amber[100],
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: size.height * 0.23,
                    width: 120.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/main_top.png'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: size.height * 0.18,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/login_bottom.png'),
                      ),
                    ),
                  ),
                ),
                child!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
