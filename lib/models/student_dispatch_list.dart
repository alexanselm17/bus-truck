class StudentPatchList {
  StudentDispatch? studentDispatch;

  StudentPatchList({this.studentDispatch});

  StudentPatchList.fromJson(Map<String, dynamic> json) {
    studentDispatch = json['data'] != null
        ? new StudentDispatch.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentDispatch'] = this.studentDispatch!.toJson();
      return data;
  }
}

class StudentDispatch {
  int ?id;
  int ?schoolId;
  String? name;
  String? createdAt;
  String ?updatedAt;
  List<Students>? students;

  StudentDispatch(
      {this.id,
      this.schoolId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.students});

  StudentDispatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolId = json['school_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['students'] != null) {
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['school_id'] = this.schoolId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['students'] = this.students!.map((v) => v.toJson()).toList();
      return data;
  }
}

class Students {
  int? id;
  int? parentId;
  int ?schoolId;
  String? name;
  String ?latitude;
  String? longitude;
  String ?locationName;
  String? createdAt;
  String? updatedAt;
  Pivot ?pivot;
  Parent? parent;

  Students(
      {this.id,
      this.parentId,
      this.schoolId,
      this.name,
      this.latitude,
      this.longitude,
      this.locationName,
      this.createdAt,
      this.updatedAt,
      this.pivot,
      this.parent});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    schoolId = json['school_id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationName = json['location_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    parent =
        json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['school_id'] = this.schoolId;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location_name'] = this.locationName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pivot'] = this.pivot!.toJson();
      data['parent'] = this.parent!.toJson();
      return data;
  }
}

class Pivot {
  int ?dispatchId;
  int ?studentId;

  Pivot({this.dispatchId, this.studentId});

  Pivot.fromJson(Map<String, dynamic> json) {
    dispatchId = json['dispatch_id'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_id'] = this.dispatchId;
    data['student_id'] = this.studentId;
    return data;
  }
}

class Parent {
  int? id;
  String ?name;
  String? email;
  String? phone;
  String ?emailVerifiedAt;
  int? accountType;
  int? schoolId;
  int? status;
  String? deviceToken;
  String ?createdAt;
  String ?updatedAt;

  Parent(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.accountType,
      this.schoolId,
      this.status,
      this.deviceToken,
      this.createdAt,
      this.updatedAt});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    accountType = json['account_type'];
    schoolId = json['school_id'];
    status = json['status'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['account_type'] = this.accountType;
    data['school_id'] = this.schoolId;
    data['status'] = this.status;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
