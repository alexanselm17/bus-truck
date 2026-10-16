class StudentGuardian {
  Students? data;

  StudentGuardian({this.data});

  StudentGuardian.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Students.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data!.toJson();
      return data;
  }
}

class Students {
  int ?id;
  int ?parentId;
  int? schoolId;
  String? name;
  String ?adminNo;
  String? latitude;
  String? longitude;
  String ?locationName;
  dynamic subscribed;
  String ?createdAt;
  String? updatedAt;
  List<Guardians>? guardians;

  Students(
      {this.id,
      this.parentId,
      this.schoolId,
      this.name,
      this.adminNo,
      this.latitude,
      this.longitude,
      this.locationName,
      this.subscribed,
      this.createdAt,
      this.updatedAt,
      this.guardians});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    schoolId = json['school_id'];
    name = json['name'];
    adminNo = json['admin_no'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationName = json['location_name'];
    subscribed = json['subscribed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['guardians'] != null) {
      json['guardians'].forEach((v) {
        guardians!.add(new Guardians.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['school_id'] = this.schoolId;
    data['name'] = this.name;
    data['admin_no'] = this.adminNo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location_name'] = this.locationName;
    data['subscribed'] = this.subscribed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['guardians'] = this.guardians!.map((v) => v.toJson()).toList();
      return data;
  }
}

class Guardians {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? accountType;
  dynamic schoolId;
  int? status;
  Null deviceToken;
  String ?createdAt;
  String? updatedAt;
  Null deletedAt;
  Pivot? pivot;

  Guardians(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.accountType,
      this.schoolId,
      this.status,
      this.deviceToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.pivot});

  Guardians.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    accountType = json['account_type'];
    schoolId = json['school_id'];
    status = json['status'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['account_type'] = this.accountType;
    data['school_id'] = this.schoolId;
    data['status'] = this.status;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['pivot'] = this.pivot!.toJson();
      return data;
  }
}

class Pivot {
  int? studentId;
  int? userId;
  String? relation;

  Pivot({this.studentId, this.userId, this.relation});

  Pivot.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    userId = json['user_id'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['user_id'] = this.userId;
    data['relation'] = this.relation;
    return data;
  }
}
