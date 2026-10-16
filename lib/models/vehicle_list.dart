
import 'dart:convert';

VehicleList vehicleListFromJson(String str) => VehicleList.fromJson(json.decode(str));

String vehicleListToJson(VehicleList data) => json.encode(data.toJson());

class VehicleList {
    List<Vehicle>? data;

    VehicleList({
        this.data,
    });

    factory VehicleList.fromJson(Map<String, dynamic> json) => VehicleList(
        data: json["data"] == null ? [] : List<Vehicle>.from(json["data"]!.map((x) => Vehicle.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Vehicle {
    int? id;
    int? providerId;
    int? schoolId;
    int? driverId;
    String? plateNo;
    String? capacity;
    dynamic avatar;
    String? alias;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic deletedAt;

    Vehicle({
        this.id,
        this.providerId,
        this.schoolId,
        this.driverId,
        this.plateNo,
        this.capacity,
        this.avatar,
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
        alias: json["alias"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "alias": alias,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
