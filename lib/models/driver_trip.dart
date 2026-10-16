class DriverTripModel {
  List<Trip>? trip;
  Meta? meta;

  DriverTripModel({this.trip, this.meta});

  factory DriverTripModel.fromJson(Map<String, dynamic> json) =>
      DriverTripModel(
        trip: json["data"] == null
            ? []
            : List<Trip>.from(json["data"]!.map((x) => Trip.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip'] = this.trip!.map((v) => v.toJson()).toList();
    data['meta'] = this.meta!.toJson();
    return data;
  }
}

class Trip {
  int? id;
  dynamic name;
  int? vehicleId;
  int? driverId;
  int? dispatchId;
  dynamic latitude;
  dynamic longitude;
  String? startAt;
  String? endAt;
  int? type;
  String? createdAt;
  String? updatedAt;
  Dispatch? dispatch;
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
      this.dispatch,
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
    dispatch = json['dispatch'] != null
        ? new Dispatch.fromJson(json['dispatch'])
        : null;
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
    data['dispatch'] = this.dispatch!.toJson();
    data['vehicle'] = this.vehicle!.toJson();
    return data;
  }
}

class Dispatch {
  int? id;
  int? schoolId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Dispatch({this.id, this.schoolId, this.name, this.createdAt, this.updatedAt});

  Dispatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolId = json['school_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['school_id'] = this.schoolId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
  String? createdAt;
  String? updatedAt;

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
      this.updatedAt});

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
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}
