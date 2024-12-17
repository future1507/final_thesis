// To parse this JSON data, do
//
//     final annotation = annotationFromJson(jsonString);

import 'dart:convert';

List<Annotation> annotationFromJson(String str) => List<Annotation>.from(json.decode(str).map((x) => Annotation.fromJson(x)));

String annotationToJson(List<Annotation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Annotation {
  String annoId;
  String annotations;
  String annoName;
  String? descs;
  DateTime created;
  String creatorId;
  String itemId;
  DateTime updated;
  String updateId;
  int isshow;

  Annotation({
    required this.annoId,
    required this.annotations,
    required this.annoName,
    required this.descs,
    required this.created,
    required this.creatorId,
    required this.itemId,
    required this.updated,
    required this.updateId,
    required this.isshow,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) => Annotation(
    annoId: json["anno_id"],
    annotations: json["annotations"],
    annoName: json["anno_name"],
    descs: json["descs"],
    created: DateTime.parse(json["created"]),
    creatorId: json["creator_id"],
    itemId: json["item_id"],
    updated: DateTime.parse(json["updated"]),
    updateId: json["update_id"],
    isshow: json["isshow"],
  );

  Map<String, dynamic> toJson() => {
    "anno_id": annoId,
    "annotations": annotations,
    "anno_name": annoName,
    "descs": descs,
    "created": created.toIso8601String(),
    "creator_id": creatorId,
    "item_id": itemId,
    "updated": updated.toIso8601String(),
    "update_id": updateId,
    "isshow": isshow,
  };
}
