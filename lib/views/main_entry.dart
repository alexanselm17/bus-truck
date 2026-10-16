import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/common_widgets/guest_background.dart';
import 'package:school_tracker/providers/location_provider.dart';
import 'package:school_tracker/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/driver_provider.dart';
import '../providers/parent_provider.dart';
import '../utils/user_shared_pref.dart';
import 'authentication/login.dart';
import 'dashboard.dart';
import 'driver/driver_home_shell.dart';

class MainEntry extends StatefulWidget {
  @override
  _MainEntryState createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<UserPreferences>().getUser();
      if (!mounted) return;
      await openNextPage();
    });
  }

  openNextPage() async {
    preferences = await SharedPreferences.getInstance();
    try {
      String? firstTimer = preferences.getString(AppConstants.INITIAL_LAUNCH);
      int? accountType = preferences.getInt(AppConstants.ACCOUNT_TYPE);
      int? userId = preferences.getInt("userId");

      await Future.delayed(const Duration(seconds: 1));
      if (firstTimer == null || userId == null) {
        await preferences.setString(AppConstants.INITIAL_LAUNCH, "no");
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else if (accountType == 1) {
        await Provider.of<DriverProvider>(context, listen: false)
            .getDriverTrips(userId);
        await Provider.of<LocationProvider>(context, listen: false)
            .setUpPositionLocator();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverHomeShell()),
        );
      } else {
        await Provider.of<ParentProvider>(context, listen: false)
            .isThereStudentsOnRoute();
        await Provider.of<LocationProvider>(context, listen: false)
            .setUpPositionLocator();
        Provider.of<ParentProvider>(context, listen: false).getParentSchools();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoardPage()),
        );
      }
    } on PlatformException catch (e) {
      print("this is a platform ex ::$e");
      await preferences.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundPage(
      child: Center(
          child: Image.asset(
        "assets/images/logo.png",
        height: 100,
      )),
    ));
  }
}
