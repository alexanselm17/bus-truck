class VehicleLocation {
  List<Location>? location;

  VehicleLocation({this.location});

  VehicleLocation.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        location!.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location!.map((v) => v.toJson()).toList();
      return data;
  }
}

class Location {
  int? id;
  int? vehicleId;
  String? latitude;
  String? longitude;
  int? velocity;
  String ?createdAt;
  String ?updatedAt;

  Location(
      {this.id,
      this.vehicleId,
      this.latitude,
      this.longitude,
      this.velocity,
      this.createdAt,
      this.updatedAt});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    velocity = json['velocity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_id'] = this.vehicleId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['velocity'] = this.velocity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
