class PaymentPlanModel {
  List<Plan>? plan;

  PaymentPlanModel({this.plan});

  factory PaymentPlanModel.fromJson(Map<String, dynamic> json) =>
      PaymentPlanModel(
        plan: json["data"] == null
            ? []
            : List<Plan>.from(json["data"]!.map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = this.plan!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Plan {
  int? id;
  String? name;
  String? description;
  String? amount;
  dynamic cost;
  String? period;
  int? status;
  String? createdAt;
  String? updatedAt;

  Plan(
      {this.id,
      this.name,
      this.description,
      this.amount,
      this.cost,
      this.period,
      this.status,
      this.createdAt,
      this.updatedAt});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    amount = json['amount'];
    period = json['period'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['period'] = this.period;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
