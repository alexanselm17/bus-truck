// To parse this JSON data, do
//
//     final activeStudentModel = activeStudentModelFromJson(jsonString);

import 'dart:convert';

ActiveStudentModel activeStudentModelFromJson(String str) =>
    ActiveStudentModel.fromJson(json.decode(str));

String activeStudentModelToJson(ActiveStudentModel data) =>
    json.encode(data.toJson());

class ActiveStudentModel {
  List<ActiveStudents>? data;

  ActiveStudentModel({
    this.data,
  });

  factory ActiveStudentModel.fromJson(Map<String, dynamic> json) =>
      ActiveStudentModel(
        data: json["data"] == null
            ? []
            : List<ActiveStudents>.from(
                json["data"]!.map((x) => ActiveStudents.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ActiveStudents {
  int? id;
  int? parentId;
  int? schoolId;
  String? name;
  String? adminNo;
  String? latitude;
  String? longitude;
  String? locationName;
  int? subscribed;
  int? pendingLocationUpdate;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  ActiveTripHistory? activeTripHistory;

  ActiveStudents({
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
    this.activeTripHistory,
  });

  factory ActiveStudents.fromJson(Map<String, dynamic> json) => ActiveStudents(
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
        activeTripHistory: json["active_trip_history"] == null
            ? null
            : ActiveTripHistory.fromJson(json["active_trip_history"]),
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
        "active_trip_history": activeTripHistory?.toJson(),
      };
}

class ActiveTripHistory {
  int? id;
  int? studentId;
  int? tripId;
  int? userId;
  DateTime? actionTime;
  dynamic dropPickTime;
  dynamic data;
  dynamic skipped;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic skippedReason;
  dynamic driverDroppedStudent;
  dynamic guardianPicked;
  Trip? trip;

  ActiveTripHistory({
    this.id,
    this.studentId,
    this.tripId,
    this.userId,
    this.actionTime,
    this.dropPickTime,
    this.data,
    this.skipped,
    this.createdAt,
    this.updatedAt,
    this.skippedReason,
    this.driverDroppedStudent,
    this.guardianPicked,
    this.trip,
  });

  factory ActiveTripHistory.fromJson(Map<String, dynamic> json) =>
      ActiveTripHistory(
        id: json["id"],
        studentId: json["student_id"],
        tripId: json["trip_id"],
        userId: json["user_id"],
        actionTime: json["action_time"] == null
            ? null
            : DateTime.parse(json["action_time"]),
        dropPickTime: json["drop_pick_time"],
        data: json["data"],
        skipped: json["skipped"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        skippedReason: json["skipped_reason"],
        driverDroppedStudent: json["driver_dropped_student"],
        guardianPicked: json["guardian_picked"],
        trip: json["trip"] == null ? null : Trip.fromJson(json["trip"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "trip_id": tripId,
        "user_id": userId,
        "action_time": actionTime?.toIso8601String(),
        "drop_pick_time": dropPickTime,
        "data": data,
        "skipped": skipped,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "skipped_reason": skippedReason,
        "driver_dropped_student": driverDroppedStudent,
        "guardian_picked": guardianPicked,
        "trip": trip?.toJson(),
      };
}

class Trip {
  int? id;
  dynamic name;
  int? vehicleId;
  int? driverId;
  int? dispatchId;
  String? latitude;
  String? longitude;
  DateTime? startAt;
  dynamic endAt;
  int? type;
  dynamic endLatitude;
  dynamic endLongitude;
  dynamic awaitingValidation;
  dynamic audits;
  DateTime? createdAt;
  DateTime? updatedAt;
  Driver? driver;
  Vehicle? vehicle;

  Trip({
    this.id,
    this.name,
    this.vehicleId,
    this.driverId,
    this.dispatchId,
    this.latitude,
    this.longitude,
    this.startAt,
    this.endAt,
    this.type,
    this.endLatitude,
    this.endLongitude,
    this.awaitingValidation,
    this.audits,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.vehicle,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json["id"],
        name: json["name"],
        vehicleId: json["vehicle_id"],
        driverId: json["driver_id"],
        dispatchId: json["dispatch_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        startAt:
            json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
        endAt: json["end_at"],
        type: json["type"],
        endLatitude: json["end_latitude"],
        endLongitude: json["end_longitude"],
        awaitingValidation: json["awaiting_validation"],
        audits: json["audits"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "vehicle_id": vehicleId,
        "driver_id": driverId,
        "dispatch_id": dispatchId,
        "latitude": latitude,
        "longitude": longitude,
        "start_at": startAt?.toIso8601String(),
        "end_at": endAt,
        "type": type,
        "end_latitude": endLatitude,
        "end_longitude": endLongitude,
        "awaiting_validation": awaitingValidation,
        "audits": audits,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "driver": driver?.toJson(),
        "vehicle": vehicle?.toJson(),
      };
}

class Driver {
  int? id;
  String? name;
  String? email;
  String? phone;
  DateTime? emailVerifiedAt;
  dynamic canAccessWeb;
  int? schoolId;
  int? status;
  DateTime? lastLogin;
  dynamic address;
  String? idNo;
  String? drivingLicence;
  String? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Permissions? permissions;
  List<Role>? roles;
  Permissions? allPermissions;

  Driver({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.canAccessWeb,
    this.schoolId,
    this.status,
    this.lastLogin,
    this.address,
    this.idNo,
    this.drivingLicence,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.permissions,
    this.roles,
    this.allPermissions,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        canAccessWeb: json["can_access_web"],
        schoolId: json["school_id"],
        status: json["status"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
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
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        allPermissions: json["allPermissions"] == null
            ? null
            : Permissions.fromJson(json["allPermissions"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "can_access_web": canAccessWeb,
        "school_id": schoolId,
        "status": status,
        "last_login": lastLogin?.toIso8601String(),
        "address": address,
        "id_no": idNo,
        "driving_licence": drivingLicence,
        "device_token": deviceToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "permissions": permissions?.toJson(),
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "allPermissions": allPermissions?.toJson(),
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

class Role {
  int? id;
  String? title;
  dynamic schoolId;
  Permissions? permissions;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

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
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
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

class Pivot {
  int? userId;
  int? roleId;

  Pivot({
    this.userId,
    this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "role_id": roleId,
      };
}

class Vehicle {
  int? id;
  dynamic providerId;
  int? schoolId;
  int? driverId;
  String? plateNo;
  String? capacity;
  dynamic avatar;
  int? status;
  String? alias;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Vehicle({
    this.id,
    this.providerId,
    this.schoolId,
    this.driverId,
    this.plateNo,
    this.capacity,
    this.avatar,
    this.status,
    this.alias,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        providerId: json["provider_id"],
        schoolId: json["school_id"],
        driverId: json["driver_id"],
        plateNo: json["plate_no"],
        capacity: json["capacity"],
        avatar: json["avatar"],
        status: json["status"],
        alias: json["alias"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "school_id": schoolId,
        "driver_id": driverId,
        "plate_no": plateNo,
        "capacity": capacity,
        "avatar": avatar,
        "status": status,
        "alias": alias,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
