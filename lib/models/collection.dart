// To parse this JSON data, do
//
//     final collection = collectionFromJson(jsonString);

import 'dart:convert';

List<Collection> collectionFromJson(String str) => List<Collection>.from(json.decode(str).map((x) => Collection.fromJson(x)));

String collectionToJson(List<Collection> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Collection {
  int accessLevel;
  String id;
  String modelType;
  DateTime created;
  String? description;
  Meta meta;
  String name;
  bool public;
  List<dynamic>? publicFlags;
  int size;
  DateTime updated;

  Collection({
    required this.accessLevel,
    required this.id,
    required this.modelType,
    required this.created,
    required this.description,
    required this.meta,
    required this.name,
    required this.public,
    this.publicFlags,
    required this.size,
    required this.updated,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    accessLevel: json["_accessLevel"],
    id: json["_id"],
    modelType: json["_modelType"],
    created: DateTime.parse(json["created"]),
    description: json["description"],
    meta: Meta.fromJson(json["meta"]),
    name: json["name"],
    public: json["public"],
    publicFlags: json["publicFlags"] == null ? [] : List<dynamic>.from(json["publicFlags"]!.map((x) => x)),
    size: json["size"],
    updated: DateTime.parse(json["updated"]),
  );

  Map<String, dynamic> toJson() => {
    "_accessLevel": accessLevel,
    "_id": id,
    "_modelType": modelType,
    "created": created.toIso8601String(),
    "description": description,
    "meta": meta.toJson(),
    "name": name,
    "public": public,
    "publicFlags": publicFlags == null ? [] : List<dynamic>.from(publicFlags!.map((x) => x)),
    "size": size,
    "updated": updated.toIso8601String(),
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
