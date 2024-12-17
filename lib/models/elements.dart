// To parse this JSON data, do
//
//     final elements = elementsFromJson(jsonString);

import 'dart:convert';

List<Elements> elementsFromJson(String str) => List<Elements>.from(json.decode(str).map((x) => Elements.fromJson(x)));

String elementsToJson(List<Elements> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Elements {
  String id;
  double size;
  String type;
  String color;
  int sides;
  bool filled;
  List<Point> points;

  Elements({
    required this.id,
    required this.size,
    required this.type,
    required this.color,
    required this.sides,
    required this.filled,
    required this.points,
  });

  factory Elements.fromJson(Map<String, dynamic> json) => Elements(
    id: json["id"],
    size: json["size"],
    type: json["type"],
    color: json["color"],
    sides: json["sides"],
    filled: json["filled"],
    points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "size": size,
    "type": type,
    "color": color,
    "sides": sides,
    "filled": filled,
    "points": List<dynamic>.from(points.map((x) => x.toJson())),
  };
}

class Point {
  double dx;
  double dy;

  Point({
    required this.dx,
    required this.dy,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    dx: json["dx"]?.toDouble(),
    dy: json["dy"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "dx": dx,
    "dy": dy,
  };
}
