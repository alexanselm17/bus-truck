import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:school_tracker/services/inittial_binding.dart';
import 'package:school_tracker/views/payments/payment_history.dart';
import 'package:school_tracker/views/profile_page.dart';
import 'package:school_tracker/views/student_collection.dart';
import 'providers/app_state.dart';
import 'providers/auth_provider.dart';
import 'providers/dispatch_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/location_provider.dart';
import 'providers/parent_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/student_provider.dart';
import 'providers/trip_history_provider.dart';
import 'providers/user_provider.dart';
import 'providers/vehicle_provider.dart';
import 'services/NavigationService.dart';
import 'services/OsrmApi.dart';
import 'utils/http_cert_override.dart';
import 'utils/app_theme.dart';
import 'utils/user_shared_pref.dart';
import 'views/authentication/login.dart';
import 'views/main_entry.dart';
import 'service_locator.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  InitialBinding.networkInit();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserPreferences()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => TripHistory()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => DispatchProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => ProviderMaps()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          title: 'School Track',
          theme: AppTheme.light,
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: (routeSettings) {
            switch (routeSettings.name) {
              case 'login':
                return MaterialPageRoute(builder: (context) => Login());
              case 'payment':
                return MaterialPageRoute(
                    builder: (context) => PaymentHistory());
              case 'profile':
                return MaterialPageRoute(builder: (context) => ProfilePage());
              case 'on-route':
                return MaterialPageRoute(
                    builder: (context) => StudentCollection());

              default:
                return MaterialPageRoute(builder: (context) => MainEntry());
            }
          },
          home: MainEntry()),
    );
  }
}
