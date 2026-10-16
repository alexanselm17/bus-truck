class LocationPendingApproval {
  int? id;
  int? studentId;
  int? approverId;
  int? requesterId;
  String? latitude;
  String? longitude;
  String? locationName;
  int? status;
  String? createdAt;
  String? updatedAt;

  LocationPendingApproval(
      {this.id,
      this.studentId,
      this.approverId,
      this.requesterId,
      this.latitude,
      this.longitude,
      this.locationName,
      this.status,
      this.createdAt,
      this.updatedAt});

  LocationPendingApproval.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    approverId = json['approver_id'];
    requesterId = json['requester_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationName = json['location_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['approver_id'] = this.approverId;
    data['requester_id'] = this.requesterId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location_name'] = this.locationName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
