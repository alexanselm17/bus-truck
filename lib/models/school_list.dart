class SchoolList {
  List<Schools>? schools;

  SchoolList({this.schools});

  factory SchoolList.fromJson(Map<String, dynamic> json) => SchoolList(
        schools: json["data"] == null
            ? []
            : List<Schools>.from(json["data"]!.map((x) => Schools.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schools'] = this.schools!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Schools {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? website;
  String? latitude;
  String? longitude;
  int? subscriptionType;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Schools(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.website,
      this.latitude,
      this.longitude,
      this.subscriptionType,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Schools.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    website = json['website'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    subscriptionType = json['subscription_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['website'] = this.website;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['subscription_type'] = this.subscriptionType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pivot'] = this.pivot!.toJson();
    return data;
  }
}

class Pivot {
  int? userId;
  int? schoolId;

  Pivot({this.userId, this.schoolId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    schoolId = json['school_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['school_id'] = this.schoolId;
    return data;
  }
}
