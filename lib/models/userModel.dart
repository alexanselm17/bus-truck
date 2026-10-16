class UserModel {
  User? user;
  String? token;

  UserModel({this.user, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user!.toJson();
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  dynamic canAccessWeb;
  int? schoolId;
  int? status;
  dynamic deviceToken;
  String? createdAt;
  String? updatedAt;
  Permissions? permissions;
  List<Roles>? roles;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.canAccessWeb,
      this.schoolId,
      this.status,
      this.deviceToken,
      this.createdAt,
      this.updatedAt,
      this.permissions,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    canAccessWeb = json['can_access_web'];
    schoolId = json['school_id'];
    status = json['status'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    permissions = json['permissions'] != null
        ? new Permissions.fromJson(json['permissions'])
        : null;

    roles = json["roles"] == null
        ? []
        : List<Roles>.from(json["roles"]!.map((x) => Roles.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['can_access_web'] = this.canAccessWeb;
    data['school_id'] = this.schoolId;
    data['status'] = this.status;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['permissions'] = this.permissions!.toJson();
    data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Permissions {
  App? app;

  Permissions({
    this.app,
  });

  Permissions.fromJson(Map<String, dynamic> json) {
    app = json['app'] != null ? new App.fromJson(json['app']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app'] = this.app!.toJson();

    return data;
  }
}

class App {
  bool? addGuardian;
  bool? createTrips;
  bool? pickStudent;
  bool? showGuardian;

  App(
      {this.addGuardian,
      this.createTrips,
      this.pickStudent,
      this.showGuardian});

  App.fromJson(Map<String, dynamic> json) {
    addGuardian = json['add_guardian'];
    createTrips = json['create_trips'];
    pickStudent = json['pick_student'];
    showGuardian = json['show_guardian'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['add_guardian'] = this.addGuardian;
    data['create_trips'] = this.createTrips;
    data['pick_student'] = this.pickStudent;
    data['show_guardian'] = this.showGuardian;
    return data;
  }
}

class Roles {
  int? id;
  String? title;
  Null schoolId;
  Permissions? permissions;
  String? description;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles(
      {this.id,
      this.title,
      this.schoolId,
      this.permissions,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    schoolId = json['school_id'];
    permissions = json['permissions'] != null
        ? new Permissions.fromJson(json['permissions'])
        : null;
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['school_id'] = this.schoolId;
    data['permissions'] = this.permissions!.toJson();
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pivot'] = this.pivot!.toJson();
    return data;
  }
}

class Pivot {
  int? userId;
  int? roleId;

  Pivot({this.userId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    return data;
  }
}
