class GuardianModel {
    GuardianModel({
        required this.data,
    });

    final Data? data;

    factory GuardianModel.fromJson(Map<String, dynamic> json){ 
        return GuardianModel(
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.id,
        required this.parentId,
        required this.schoolId,
        required this.name,
        required this.adminNo,
        required this.latitude,
        required this.longitude,
        required this.locationName,
        required this.subscribed,
        required this.pendingLocationUpdate,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.guardians,
    });

    final int? id;
    final int? parentId;
    final int? schoolId;
    final String? name;
    final String? adminNo;
    final String? latitude;
    final String? longitude;
    final String? locationName;
    final dynamic subscribed;
    final int? pendingLocationUpdate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final List<Guardian> guardians;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
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
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
            guardians: json["guardians"] == null ? [] : List<Guardian>.from(json["guardians"]!.map((x) => Guardian.fromJson(x))),
        );
    }

}

class Guardian {
    Guardian({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.emailVerifiedAt,
        required this.canAccessWeb,
        required this.schoolId,
        required this.status,
        required this.address,
        required this.idNo,
        required this.drivingLicence,
        required this.deviceToken,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.permissions,
        required this.pivot,
        required this.roles,
    });

    final int? id;
    final String? name;
    final String? email;
    final String? phone;
    final dynamic emailVerifiedAt;
    final dynamic canAccessWeb;
    final dynamic schoolId;
    final int? status;
    final dynamic address;
    final dynamic idNo;
    final dynamic drivingLicence;
    final dynamic deviceToken;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final Permissions? permissions;
    final GuardianPivot? pivot;
    final List<Role> roles;

    factory Guardian.fromJson(Map<String, dynamic> json){ 
        return Guardian(
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
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
            permissions: json["permissions"] == null ? null : Permissions.fromJson(json["permissions"]),
            pivot: json["pivot"] == null ? null : GuardianPivot.fromJson(json["pivot"]),
            roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        );
    }

}

class Permissions {
    Permissions({
        required this.app,
        required this.plans,
        required this.roles,
        required this.trips,
        required this.users,
        required this.topUp,
        required this.drivers,
        required this.parents,
        required this.reports,
        required this.schools,
        required this.tickets,
        required this.dispatch,
        required this.students,
        required this.vehicles,
        required this.providers,
        required this.contactUs,
        required this.ticketCategories,
    });

    final App? app;
    final Dispatch? plans;
    final Dispatch? roles;
    final Trips? trips;
    final Users? users;
    final ContactUs? topUp;
    final Dispatch? drivers;
    final Dispatch? parents;
    final Reports? reports;
    final Dispatch? schools;
    final Dispatch? tickets;
    final Dispatch? dispatch;
    final Students? students;
    final Dispatch? vehicles;
    final Dispatch? providers;
    final ContactUs? contactUs;
    final Dispatch? ticketCategories;

    factory Permissions.fromJson(Map<String, dynamic> json){ 
        return Permissions(
            app: json["app"] == null ? null : App.fromJson(json["app"]),
            plans: json["plans"] == null ? null : Dispatch.fromJson(json["plans"]),
            roles: json["roles"] == null ? null : Dispatch.fromJson(json["roles"]),
            trips: json["trips"] == null ? null : Trips.fromJson(json["trips"]),
            users: json["users"] == null ? null : Users.fromJson(json["users"]),
            topUp: json["top_up"] == null ? null : ContactUs.fromJson(json["top_up"]),
            drivers: json["drivers"] == null ? null : Dispatch.fromJson(json["drivers"]),
            parents: json["parents"] == null ? null : Dispatch.fromJson(json["parents"]),
            reports: json["reports"] == null ? null : Reports.fromJson(json["reports"]),
            schools: json["schools"] == null ? null : Dispatch.fromJson(json["schools"]),
            tickets: json["tickets"] == null ? null : Dispatch.fromJson(json["tickets"]),
            dispatch: json["dispatch"] == null ? null : Dispatch.fromJson(json["dispatch"]),
            students: json["students"] == null ? null : Students.fromJson(json["students"]),
            vehicles: json["vehicles"] == null ? null : Dispatch.fromJson(json["vehicles"]),
            providers: json["providers"] == null ? null : Dispatch.fromJson(json["providers"]),
            contactUs: json["contact_us"] == null ? null : ContactUs.fromJson(json["contact_us"]),
            ticketCategories: json["ticket-categories"] == null ? null : Dispatch.fromJson(json["ticket-categories"]),
        );
    }

}

class App {
    App({
        required this.addGuardian,
        required this.createTrips,
        required this.pickStudent,
        required this.showGuardian,
    });

    final bool? addGuardian;
    final bool? createTrips;
    final bool? pickStudent;
    final bool? showGuardian;

    factory App.fromJson(Map<String, dynamic> json){ 
        return App(
            addGuardian: json["add_guardian"],
            createTrips: json["create_trips"],
            pickStudent: json["pick_student"],
            showGuardian: json["show_guardian"],
        );
    }

}

class ContactUs {
    ContactUs({
        required this.view,
    });

    final bool? view;

    factory ContactUs.fromJson(Map<String, dynamic> json){ 
        return ContactUs(
            view: json["view"],
        );
    }

}

class Dispatch {
    Dispatch({
        required this.view,
        required this.create,
        required this.delete,
        required this.update,
        required this.deactivate,
        required this.changeStatus,
        required this.addPayment,
        required this.viewOthers,
    });

    final bool? view;
    final bool? create;
    final bool? delete;
    final bool? update;
    final bool? deactivate;
    final bool? changeStatus;
    final bool? addPayment;
    final bool? viewOthers;

    factory Dispatch.fromJson(Map<String, dynamic> json){ 
        return Dispatch(
            view: json["view"],
            create: json["create"],
            delete: json["delete"],
            update: json["update"],
            deactivate: json["deactivate"],
            changeStatus: json["change_status"],
            addPayment: json["add_payment"],
            viewOthers: json["view-others"],
        );
    }

}

class Reports {
    Reports({
        required this.view,
        required this.admin,
    });

    final bool? view;
    final bool? admin;

    factory Reports.fromJson(Map<String, dynamic> json){ 
        return Reports(
            view: json["view"],
            admin: json["admin"],
        );
    }

}

class Students {
    Students({
        required this.view,
        required this.create,
        required this.delete,
        required this.update,
        required this.skipRides,
        required this.approveLocations,
    });

    final bool? view;
    final bool? create;
    final bool? delete;
    final bool? update;
    final bool? skipRides;
    final bool? approveLocations;

    factory Students.fromJson(Map<String, dynamic> json){ 
        return Students(
            view: json["view"],
            create: json["create"],
            delete: json["delete"],
            update: json["update"],
            skipRides: json["skip-rides"],
            approveLocations: json["approve-locations"],
        );
    }

}

class Trips {
    Trips({
        required this.view,
        required this.delete,
    });

    final bool? view;
    final bool? delete;

    factory Trips.fromJson(Map<String, dynamic> json){ 
        return Trips(
            view: json["view"],
            delete: json["delete"],
        );
    }

}

class Users {
    Users({
        required this.view,
        required this.create,
        required this.delete,
        required this.update,
        required this.impersonate,
        required this.removeRole,
        required this.changeStatus,
        required this.resetFcmToken,
    });

    final bool? view;
    final bool? create;
    final bool? delete;
    final bool? update;
    final bool? impersonate;
    final bool? removeRole;
    final bool? changeStatus;
    final bool? resetFcmToken;

    factory Users.fromJson(Map<String, dynamic> json){ 
        return Users(
            view: json["view"],
            create: json["create"],
            delete: json["delete"],
            update: json["update"],
            impersonate: json["impersonate"],
            removeRole: json["remove-role"],
            changeStatus: json["change_status"],
            resetFcmToken: json["reset-fcm-token"],
        );
    }

}

class GuardianPivot {
    GuardianPivot({
        required this.studentId,
        required this.userId,
        required this.relation,
        required this.active,
    });

    final int? studentId;
    final int? userId;
    final String? relation;
    final int? active;

    factory GuardianPivot.fromJson(Map<String, dynamic> json){ 
        return GuardianPivot(
            studentId: json["student_id"],
            userId: json["user_id"],
            relation: json["relation"],
            active: json["active"],
        );
    }

}

class Role {
    Role({
        required this.id,
        required this.title,
        required this.schoolId,
        required this.permissions,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.pivot,
    });

    final int? id;
    final String? title;
    final dynamic schoolId;
    final Permissions? permissions;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final RolePivot? pivot;

    factory Role.fromJson(Map<String, dynamic> json){ 
        return Role(
            id: json["id"],
            title: json["title"],
            schoolId: json["school_id"],
            permissions: json["permissions"] == null ? null : Permissions.fromJson(json["permissions"]),
            description: json["description"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
        );
    }

}

class RolePivot {
    RolePivot({
        required this.userId,
        required this.roleId,
    });

    final int? userId;
    final int? roleId;

    factory RolePivot.fromJson(Map<String, dynamic> json){ 
        return RolePivot(
            userId: json["user_id"],
            roleId: json["role_id"],
        );
    }

}
