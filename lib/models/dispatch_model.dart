
import 'dart:convert';

DispatchModel dispatchModelFromJson(String str) =>
    DispatchModel.fromJson(json.decode(str));

String dispatchModelToJson(DispatchModel data) => json.encode(data.toJson());

class DispatchModel {
  List<Dispatch>? data;

  DispatchModel({
    this.data,
  });

  factory DispatchModel.fromJson(Map<String, dynamic> json) => DispatchModel(
        data: json["data"] == null
            ? []
            : List<Dispatch>.from(json["data"]!.map((x) => Dispatch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Dispatch {
  int? id;
  int? schoolId;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Dispatch({
    this.id,
    this.schoolId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Dispatch.fromJson(Map<String, dynamic> json) => Dispatch(
        id: json["id"],
        schoolId: json["school_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school_id": schoolId,
        "name": name,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
