import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future permissionForLocation() async {
    final request = await [Permission.location].request();
    log(request[Permission.location].toString());
    final status = await Permission.location.status;

    if (status.isDenied) {
      request;
      return false;
    } else if (status.isRestricted) {
      request;
      return false;
    } else if (status.isLimited) {
      request;
      return false;
    } else {
      return true;
    }
  }
}
