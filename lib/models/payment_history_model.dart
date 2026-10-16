class PaymentHistoryModel {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  PaymentHistoryModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    data = json["data"] == null
        ? []
        : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x)));
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    links = json["links"] == null
        ? []
        : List<Links>.from(json["links"]!.map((x) => Links.fromJson(x)));

    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['links'] = this.links!.map((v) => v.toJson()).toList();
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? amount;
  int? status;
  dynamic transId;
  dynamic transactionNumber;
  dynamic transTime;
  String? merchantRequestId;
  String? checkoutRequestId;
  String? responseCode;
  String? responseDescription;
  String? customerMessage;
  String? referenceId;
  String? createdAt;
  String? updatedAt;
  int? studentId;
  Student? student;

  Data(
      {this.id,
      this.userId,
      this.amount,
      this.status,
      this.transId,
      this.transactionNumber,
      this.transTime,
      this.merchantRequestId,
      this.checkoutRequestId,
      this.responseCode,
      this.responseDescription,
      this.customerMessage,
      this.referenceId,
      this.createdAt,
      this.updatedAt,
      this.studentId,
      this.student});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    status = json['status'];
    transId = json['trans_id'];
    transactionNumber = json['transaction_number'];
    transTime = json['trans_time'];
    merchantRequestId = json['merchant_request_id'];
    checkoutRequestId = json['checkout_request_id'];
    responseCode = json['response_code'];
    responseDescription = json['response_description'];
    customerMessage = json['customer_message'];
    referenceId = json['reference_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    studentId = json['student_id'];
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['trans_id'] = this.transId;
    data['transaction_number'] = this.transactionNumber;
    data['trans_time'] = this.transTime;
    data['merchant_request_id'] = this.merchantRequestId;
    data['checkout_request_id'] = this.checkoutRequestId;
    data['response_code'] = this.responseCode;
    data['response_description'] = this.responseDescription;
    data['customer_message'] = this.customerMessage;
    data['reference_id'] = this.referenceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['student_id'] = this.studentId;
    data['student'] = this.student!.toJson();
    return data;
  }
}

class Student {
  int? id;
  int? parentId;
  int? schoolId;
  String? name;
  String? adminNo;
  String? latitude;
  String? longitude;
  String? locationName;
  dynamic subscribed;
  String? createdAt;
  String? updatedAt;

  Student(
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
      this.updatedAt});

  Student.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
