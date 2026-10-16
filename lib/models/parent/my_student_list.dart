// To parse this JSON data, do
//
//     final myStudentModel = myStudentModelFromJson(jsonString);

import 'dart:convert';

MyStudentModel myStudentModelFromJson(String str) =>
    MyStudentModel.fromJson(json.decode(str));

String myStudentModelToJson(MyStudentModel data) => json.encode(data.toJson());

class MyStudentModel {
  List<Student>? data;

  MyStudentModel({
    this.data,
  });

  factory MyStudentModel.fromJson(Map<String, dynamic> json) => MyStudentModel(
        data: json["data"] == null
            ? []
            : List<Student>.from(json["data"]!.map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Student {
  int? id;
  int? parentId;
  int? schoolId;
  String? name;
  String? adminNo;
  String? latitude;
  String? longitude;
  dynamic locationName;
  int? subscribed;
  dynamic pendingLocationUpdate;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<Guardian>? guardians;

  Student({
    this.id,
    this.parentId,
    this.schoolId,
    this.name,
    this.adminNo,
    this.latitude,
    this.longitude,
    this.locationName,
    this.subscribed,
    this.pendingLocationUpdate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.guardians,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        parentId: json["parent_id"],
        schoolId: json["school_id"],
        name: json["name"],
        adminNo: json["admin_no"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        locationName: json["location_name"],
        subscribed: json["subscribed"],
        pendingLocationUpdate: json["pending_location_update"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        guardians: json["guardians"] == null
            ? []
            : List<Guardian>.from(
                json["guardians"]!.map((x) => Guardian.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "school_id": schoolId,
        "name": name,
        "admin_no": adminNo,
        "latitude": latitude,
        "longitude": longitude,
        "location_name": locationName,
        "subscribed": subscribed,
        "pending_location_update": pendingLocationUpdate,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "guardians": guardians == null
            ? []
            : List<dynamic>.from(guardians!.map((x) => x.toJson())),
      };
}

class Guardian {
  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic emailVerifiedAt;
  dynamic canAccessWeb;
  dynamic schoolId;
  int? status;
  dynamic address;
  dynamic idNo;
  dynamic drivingLicence;
  dynamic deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Permissions? permissions;
  GuardianPivot? pivot;
  List<Role>? roles;

  Guardian({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.canAccessWeb,
    this.schoolId,
    this.status,
    this.address,
    this.idNo,
    this.drivingLicence,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.permissions,
    this.pivot,
    this.roles,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        canAccessWeb: json["can_access_web"],
        schoolId: json["school_id"],
        status: json["status"],
        address: json["address"],
        idNo: json["id_no"],
        drivingLicence: json["driving_licence"],
        deviceToken: json["device_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        permissions: json["permissions"] == null
            ? null
            : Permissions.fromJson(json["permissions"]),
        pivot: json["pivot"] == null
            ? null
            : GuardianPivot.fromJson(json["pivot"]),
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "can_access_web": canAccessWeb,
        "school_id": schoolId,
        "status": status,
        "address": address,
        "id_no": idNo,
        "driving_licence": drivingLicence,
        "device_token": deviceToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "permissions": permissions?.toJson(),
        "pivot": pivot?.toJson(),
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
      };
}

class Permissions {
  App? app;
  Dispatch? plans;
  Dispatch? roles;
  Trips? trips;
  Users? users;
  ContactUs? topUp;
  Dispatch? drivers;
  Dispatch? parents;
  Reports? reports;
  Dispatch? schools;
  Dispatch? tickets;
  Dispatch? dispatch;
  Students? students;
  Dispatch? vehicles;
  Dispatch? providers;
  ContactUs? contactUs;
  Dispatch? ticketCategories;

  Permissions({
    this.app,
    this.plans,
    this.roles,
    this.trips,
    this.users,
    this.topUp,
    this.drivers,
    this.parents,
    this.reports,
    this.schools,
    this.tickets,
    this.dispatch,
    this.students,
    this.vehicles,
    this.providers,
    this.contactUs,
    this.ticketCategories,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        app: json["app"] == null ? null : App.fromJson(json["app"]),
        plans: json["plans"] == null ? null : Dispatch.fromJson(json["plans"]),
        roles: json["roles"] == null ? null : Dispatch.fromJson(json["roles"]),
        trips: json["trips"] == null ? null : Trips.fromJson(json["trips"]),
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
        topUp:
            json["top_up"] == null ? null : ContactUs.fromJson(json["top_up"]),
        drivers:
            json["drivers"] == null ? null : Dispatch.fromJson(json["drivers"]),
        parents:
            json["parents"] == null ? null : Dispatch.fromJson(json["parents"]),
        reports:
            json["reports"] == null ? null : Reports.fromJson(json["reports"]),
        schools:
            json["schools"] == null ? null : Dispatch.fromJson(json["schools"]),
        tickets:
            json["tickets"] == null ? null : Dispatch.fromJson(json["tickets"]),
        dispatch: json["dispatch"] == null
            ? null
            : Dispatch.fromJson(json["dispatch"]),
        students: json["students"] == null
            ? null
            : Students.fromJson(json["students"]),
        vehicles: json["vehicles"] == null
            ? null
            : Dispatch.fromJson(json["vehicles"]),
        providers: json["providers"] == null
            ? null
            : Dispatch.fromJson(json["providers"]),
        contactUs: json["contact_us"] == null
            ? null
            : ContactUs.fromJson(json["contact_us"]),
        ticketCategories: json["ticket-categories"] == null
            ? null
            : Dispatch.fromJson(json["ticket-categories"]),
      );

  Map<String, dynamic> toJson() => {
        "app": app?.toJson(),
        "plans": plans?.toJson(),
        "roles": roles?.toJson(),
        "trips": trips?.toJson(),
        "users": users?.toJson(),
        "top_up": topUp?.toJson(),
        "drivers": drivers?.toJson(),
        "parents": parents?.toJson(),
        "reports": reports?.toJson(),
        "schools": schools?.toJson(),
        "tickets": tickets?.toJson(),
        "dispatch": dispatch?.toJson(),
        "students": students?.toJson(),
        "vehicles": vehicles?.toJson(),
        "providers": providers?.toJson(),
        "contact_us": contactUs?.toJson(),
        "ticket-categories": ticketCategories?.toJson(),
      };
}

class App {
  bool? addGuardian;
  bool? createTrips;
  bool? pickStudent;
  bool? showGuardian;

  App({
    this.addGuardian,
    this.createTrips,
    this.pickStudent,
    this.showGuardian,
  });

  factory App.fromJson(Map<String, dynamic> json) => App(
        addGuardian: json["add_guardian"],
        createTrips: json["create_trips"],
        pickStudent: json["pick_student"],
        showGuardian: json["show_guardian"],
      );

  Map<String, dynamic> toJson() => {
        "add_guardian": addGuardian,
        "create_trips": createTrips,
        "pick_student": pickStudent,
        "show_guardian": showGuardian,
      };
}

class ContactUs {
  bool? view;

  ContactUs({
    this.view,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
        view: json["view"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
      };
}

class Dispatch {
  bool? view;
  bool? create;
  bool? delete;
  bool? update;
  bool? deactivate;
  bool? changeStatus;
  bool? addPayment;
  bool? viewOthers;

  Dispatch({
    this.view,
    this.create,
    this.delete,
    this.update,
    this.deactivate,
    this.changeStatus,
    this.addPayment,
    this.viewOthers,
  });

  factory Dispatch.fromJson(Map<String, dynamic> json) => Dispatch(
        view: json["view"],
        create: json["create"],
        delete: json["delete"],
        update: json["update"],
        deactivate: json["deactivate"],
        changeStatus: json["change_status"],
        addPayment: json["add_payment"],
        viewOthers: json["view-others"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "create": create,
        "delete": delete,
        "update": update,
        "deactivate": deactivate,
        "change_status": changeStatus,
        "add_payment": addPayment,
        "view-others": viewOthers,
      };
}

class Reports {
  bool? view;
  bool? admin;

  Reports({
    this.view,
    this.admin,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        view: json["view"],
        admin: json["admin"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "admin": admin,
      };
}

class Students {
  bool? view;
  bool? create;
  bool? delete;
  bool? update;
  bool? skipRides;
  bool? approveLocations;

  Students({
    this.view,
    this.create,
    this.delete,
    this.update,
    this.skipRides,
    this.approveLocations,
  });

  factory Students.fromJson(Map<String, dynamic> json) => Students(
        view: json["view"],
        create: json["create"],
        delete: json["delete"],
        update: json["update"],
        skipRides: json["skip-rides"],
        approveLocations: json["approve-locations"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "create": create,
        "delete": delete,
        "update": update,
        "skip-rides": skipRides,
        "approve-locations": approveLocations,
      };
}

class Trips {
  bool? view;
  bool? delete;

  Trips({
    this.view,
    this.delete,
  });

  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
        view: json["view"],
        delete: json["delete"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "delete": delete,
      };
}

class Users {
  bool? view;
  bool? create;
  bool? delete;
  bool? update;
  bool? impersonate;
  bool? removeRole;
  bool? changeStatus;
  bool? resetFcmToken;

  Users({
    this.view,
    this.create,
    this.delete,
    this.update,
    this.impersonate,
    this.removeRole,
    this.changeStatus,
    this.resetFcmToken,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        view: json["view"],
        create: json["create"],
        delete: json["delete"],
        update: json["update"],
        impersonate: json["impersonate"],
        removeRole: json["remove-role"],
        changeStatus: json["change_status"],
        resetFcmToken: json["reset-fcm-token"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "create": create,
        "delete": delete,
        "update": update,
        "impersonate": impersonate,
        "remove-role": removeRole,
        "change_status": changeStatus,
        "reset-fcm-token": resetFcmToken,
      };
}

class GuardianPivot {
  int? studentId;
  int? userId;
  String? relation;
  int? active;

  GuardianPivot({
    this.studentId,
    this.userId,
    this.relation,
    this.active,
  });

  factory GuardianPivot.fromJson(Map<String, dynamic> json) => GuardianPivot(
        studentId: json["student_id"],
        userId: json["user_id"],
        relation: json["relation"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "user_id": userId,
        "relation": relation,
        "active": active,
      };
}

class Role {
  int? id;
  String? title;
  dynamic schoolId;
  Permissions? permissions;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  RolePivot? pivot;

  Role({
    this.id,
    this.title,
    this.schoolId,
    this.permissions,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        title: json["title"],
        schoolId: json["school_id"],
        permissions: json["permissions"] == null
            ? null
            : Permissions.fromJson(json["permissions"]),
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "school_id": schoolId,
        "permissions": permissions?.toJson(),
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class RolePivot {
  int? userId;
  int? roleId;

  RolePivot({
    this.userId,
    this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) => RolePivot(
        userId: json["user_id"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "role_id": roleId,
      };
}
