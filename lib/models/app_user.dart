import 'userModel.dart';

class AppUser {
  final int? userId;
  final String? name;
  final String? email;
  final String? phone;
  final int? accountType;
  final int? schoolId;
  final int? status;
  final String? token;
  final dynamic deviceToken;
  final Permissions? permissions;

  AppUser(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.accountType,
      this.schoolId,
      this.status,
      this.token,
      this.deviceToken,
      this.permissions});
}
