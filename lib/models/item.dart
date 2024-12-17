// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  String id;
  String modelType;
  String baseParentId;
  String baseParentType;
  DateTime created;
  String creatorId;
  String description;
  String folderId;
  Meta meta;
  String name;
  int size;
  DateTime updated;
  LargeImage? largeImage;

  Item({
    required this.id,
    required this.modelType,
    required this.baseParentId,
    required this.baseParentType,
    required this.created,
    required this.creatorId,
    required this.description,
    required this.folderId,
    required this.meta,
    required this.name,
    required this.size,
    required this.updated,
    this.largeImage,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["_id"],
    modelType: json["_modelType"],
    baseParentId: json["baseParentId"],
    baseParentType: json["baseParentType"],
    created: DateTime.parse(json["created"]),
    creatorId: json["creatorId"],
    description: json["description"],
    folderId: json["folderId"],
    meta: Meta.fromJson(json["meta"]),
    name: json["name"],
    size: json["size"],
    updated: DateTime.parse(json["updated"]),
    largeImage: json["largeImage"] == null ? null : LargeImage.fromJson(json["largeImage"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "_modelType": modelType,
    "baseParentId": baseParentId,
    "baseParentType": baseParentType,
    "created": created.toIso8601String(),
    "creatorId": creatorId,
    "description": description,
    "folderId": folderId,
    "meta": meta.toJson(),
    "name": name,
    "size": size,
    "updated": updated.toIso8601String(),
    "largeImage": largeImage?.toJson(),
  };
}

class LargeImage {
  String fileId;
  String sourceName;
  String? jobId;
  String? originalId;

  LargeImage({
    required this.fileId,
    required this.sourceName,
    this.jobId,
    this.originalId,
  });

  factory LargeImage.fromJson(Map<String, dynamic> json) => LargeImage(
    fileId: json["fileId"],
    sourceName: json["sourceName"],
    jobId: json["jobId"],
    originalId: json["originalId"],
  );

  Map<String, dynamic> toJson() => {
    "fileId": fileId,
    "sourceName": sourceName,
    "jobId": jobId,
    "originalId": originalId,
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
