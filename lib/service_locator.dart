import 'dart:async';

import 'package:get_it/get_it.dart';
import 'services/NavigationService.dart';
import 'services/NotificationService.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  Timer(Duration(milliseconds: 500), () => NotificationService().initialize());
}
