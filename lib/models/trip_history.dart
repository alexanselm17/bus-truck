class TripHistoryModel {
  List<History>? history;

  TripHistoryModel({this.history});

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) =>
      TripHistoryModel(
        history: json["data"] == null
            ? []
            : List<History>.from(json["data"]!.map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['history'] = this.history!.map((v) => v.toJson()).toList();
    return data;
  }
}

class History {
  int? id;
  int? studentId;
  int? tripId;
  int? userId;
  String? actionTime;
  String? dropPickTime;
  List<Data>? data;
  String? createdAt;
  String? updatedAt;
  Trip? trip;

  History(
      {this.id,
      this.studentId,
      this.tripId,
      this.userId,
      this.actionTime,
      this.dropPickTime,
      this.data,
      this.createdAt,
      this.updatedAt,
      this.trip});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    tripId = json['trip_id'];
    userId = json['user_id'];
    actionTime = json['action_time'];
    dropPickTime = json['drop_pick_time'];
    data = json["data"] == null
        ? []
        : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x)));

    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['trip_id'] = this.tripId;
    data['user_id'] = this.userId;
    data['action_time'] = this.actionTime;
    data['drop_pick_time'] = this.dropPickTime;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    // data['trip'] = this.trip.toJson();

    return data;
  }
}

class Data {
  String? name;
  String? time;
  int? userId;
  String? eventType;
  String? geoLocation;

  Data({this.name, this.time, this.userId, this.eventType, this.geoLocation});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
    userId = json['user_id'];
    eventType = json['event_type'];
    geoLocation = json['geo_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['user_id'] = this.userId;
    data['event_type'] = this.eventType;
    data['geo_location'] = this.geoLocation;
    return data;
  }
}

class Trip {
  int? id;
  dynamic name;
  int? vehicleId;
  int? driverId;
  int? dispatchId;
  String? latitude;
  String? longitude;
  String? startAt;
  String? endAt;
  int? type;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;

  Trip(
      {this.id,
      this.name,
      this.vehicleId,
      this.driverId,
      this.dispatchId,
      this.latitude,
      this.longitude,
      this.startAt,
      this.endAt,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.vehicle});

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vehicleId = json['vehicle_id'];
    driverId = json['driver_id'];
    dispatchId = json['dispatch_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['vehicle_id'] = this.vehicleId;
    data['driver_id'] = this.driverId;
    data['dispatch_id'] = this.dispatchId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['vehicle'] = this.vehicle!.toJson();
    return data;
  }
}

class Vehicle {
  int? id;
  int? providerId;
  int? schoolId;
  dynamic driverId;
  String? plateNo;
  String? capacity;
  dynamic avatar;
  String? alias;
  dynamic createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Vehicle(
      {this.id,
      this.providerId,
      this.schoolId,
      this.driverId,
      this.plateNo,
      this.capacity,
      this.avatar,
      this.alias,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    schoolId = json['school_id'];
    driverId = json['driver_id'];
    plateNo = json['plate_no'];
    capacity = json['capacity'];
    avatar = json['avatar'];
    alias = json['alias'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['school_id'] = this.schoolId;
    data['driver_id'] = this.driverId;
    data['plate_no'] = this.plateNo;
    data['capacity'] = this.capacity;
    data['avatar'] = this.avatar;
    data['alias'] = this.alias;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
