// To parse this JSON data, do
//
//     final folder = folderFromJson(jsonString);

import 'dart:convert';

List<Folder> folderFromJson(String str) => List<Folder>.from(json.decode(str).map((x) => Folder.fromJson(x)));

String folderToJson(List<Folder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Folder {
  int accessLevel;
  String id;
  String modelType;
  String baseParentId;
  String baseParentType;
  DateTime created;
  String creatorId;
  String description;
  Meta meta;
  String name;
  String parentCollection;
  String parentId;
  bool public;
  int size;
  DateTime updated;

  Folder({
    required this.accessLevel,
    required this.id,
    required this.modelType,
    required this.baseParentId,
    required this.baseParentType,
    required this.created,
    required this.creatorId,
    required this.description,
    required this.meta,
    required this.name,
    required this.parentCollection,
    required this.parentId,
    required this.public,
    required this.size,
    required this.updated,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
    accessLevel: json["_accessLevel"],
    id: json["_id"],
    modelType: json["_modelType"],
    baseParentId: json["baseParentId"],
    baseParentType: json["baseParentType"],
    created: DateTime.parse(json["created"]),
    creatorId: json["creatorId"],
    description: json["description"],
    meta: Meta.fromJson(json["meta"]),
    name: json["name"],
    parentCollection: json["parentCollection"],
    parentId: json["parentId"],
    public: json["public"],
    size: json["size"],
    updated: DateTime.parse(json["updated"]),
  );

  Map<String, dynamic> toJson() => {
    "_accessLevel": accessLevel,
    "_id": id,
    "_modelType": modelType,
    "baseParentId": baseParentId,
    "baseParentType": baseParentType,
    "created": created.toIso8601String(),
    "creatorId": creatorId,
    "description": description,
    "meta": meta.toJson(),
    "name": name,
    "parentCollection": parentCollection,
    "parentId": parentId,
    "public": public,
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
