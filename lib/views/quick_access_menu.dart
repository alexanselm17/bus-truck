import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common_widgets/vertical_spacing.dart';
import '../utils/constants.dart';
import '../utils/user_shared_pref.dart';
import 'driver/driver_trip_list.dart';
import 'parent/my_students_list.dart';
import 'payments/payment_history.dart';
import 'profile_page.dart';
import 'student_collection.dart';

class QuickAccessMenu extends StatelessWidget {
  QuickAccessMenu();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPreferences>(builder: (context, user, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickMenuItem(
                  text: 'Payment',
                  iconData: Icons.account_balance,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentHistory()));
                  },
                ),
                QuickMenuItem(
                  text: 'Students',
                  iconData: Icons.people_outline,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyStudentsList()));
                  },
                ),
              ],
            ),
            VerticalSpacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                user.appUser.permissions!.app!.createTrips == true
                    ? QuickMenuItem(
                        text: 'Trips',
                        iconData: Icons.pin_drop_rounded,
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverTripList()));
                        },
                      )
                    : QuickMenuItem(
                        text: 'On route',
                        iconData: Icons.check,
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentCollection()));
                        },
                      ),
                QuickMenuItem(
                  text: 'Profile',
                  iconData: Icons.verified_user_sharp,
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class QuickMenuItem extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final VoidCallback press;
  const QuickMenuItem({
    Key? key,
    this.text,
    this.iconData,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: press,
      child: Column(
        children: [
          Container(
            height: size.height * 0.1,
            width: size.width * 0.25,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20.0),
              color: AppConstants.colorPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(0.2, 0.2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                iconData,
                size: 30.0,
                color: AppConstants.white,
              ),
            ),
          ),
          VerticalSpacing(),
          Text(
            text!,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
