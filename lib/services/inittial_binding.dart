import 'package:get/get.dart';
import 'package:school_tracker/services/network_provider.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NetworkController>(NetworkController());
  }

  static void networkInit() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
