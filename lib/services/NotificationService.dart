import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/route_manager.dart';
import 'package:school_tracker/service_locator.dart';
import 'package:school_tracker/services/NavigationService.dart';
import 'package:school_tracker/services/local_notifications_services.dart';
import '../providers/user_provider.dart';

Future handleBackgroundMessage(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    await LocalNotificationService.initialize(Get.context!);
    LocalNotificationService.display(message);
  } catch (e) {
    print("catch error $e");
  }
}

class NotificationService {
  Future initialize() async {
    await Firebase.initializeApp();
    final _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('::::::token');
    print('::::::${token.toString()}');
    initPushNotifications();
    LocalNotificationService.initialize(Get.context!);
  }

  handleMessage([RemoteMessage? message]) {
    if (message == null) return;
    // Todo add check for what page to navigate to.
    // message.data['page'] == 1?
    locator<NavigationService>().navigateTo('on-route');
  }

  // for Ios
  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => handleMessage);
    // on foreground
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // on background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // listen to message on app running state
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification == null) return;
      LocalNotificationService.display(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("FirebaseMessaging.getInitialMessage");
      if (message != null) {
        // Todo add check for what page to navigate to.
        // message.data['page'] == 1?
        locator<NavigationService>().navigateTo('on-route');
      }
    });
  }

  /// get new fcm token and update user endpoint.
  Future updateFcmToken() async {
    String token = await FirebaseMessaging.instance
        .getToken()
        .then((value) => value.toString());
    UserProvider().updateToken(token);
    return token;
  }
}
