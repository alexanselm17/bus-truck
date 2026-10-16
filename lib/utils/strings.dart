class AppStrings {
  static const String appName = "School Tracker";
  static String baseURl = AppStrings.baseURl;
  static const String ErrorMessage =
      "An error has Occurred Please try again later";

  static DateTime currentTime() {
    DateTime now = new DateTime.now();
    return DateTime(
            now.year, now.month, now.day, now.hour, now.minute, now.second)
        .toLocal();
  }
}
