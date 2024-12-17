// To parse this JSON data, do
//
//     final authentication = authenticationFromJson(jsonString);

import 'dart:convert';

Authentication authenticationFromJson(String str) => Authentication.fromJson(json.decode(str));

String authenticationToJson(Authentication data) => json.encode(data.toJson());

class Authentication {
  AuthToken authToken;
  String message;
  User user;

  Authentication({
    required this.authToken,
    required this.message,
    required this.user,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
    authToken: AuthToken.fromJson(json["authToken"]),
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "authToken": authToken.toJson(),
    "message": message,
    "user": user.toJson(),
  };
}

class AuthToken {
  DateTime expires;
  List<String> scope;
  String token;

  AuthToken({
    required this.expires,
    required this.scope,
    required this.token,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
    expires: DateTime.parse(json["expires"]),
    scope: List<String>.from(json["scope"].map((x) => x)),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "expires": expires.toIso8601String(),
    "scope": List<dynamic>.from(scope.map((x) => x)),
    "token": token,
  };
}

class User {
  int accessLevel;
  String id;
  String modelType;
  bool admin;
  DateTime created;
  String email;
  bool emailVerified;
  String firstName;
  List<dynamic> groupInvites;
  List<dynamic> groups;
  String lastName;
  String login;
  bool otp;
  bool public;
  int size;
  String status;

  User({
    required this.accessLevel,
    required this.id,
    required this.modelType,
    required this.admin,
    required this.created,
    required this.email,
    required this.emailVerified,
    required this.firstName,
    required this.groupInvites,
    required this.groups,
    required this.lastName,
    required this.login,
    required this.otp,
    required this.public,
    required this.size,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    accessLevel: json["_accessLevel"],
    id: json["_id"],
    modelType: json["_modelType"],
    admin: json["admin"],
    created: DateTime.parse(json["created"]),
    email: json["email"],
    emailVerified: json["emailVerified"],
    firstName: json["firstName"],
    groupInvites: List<dynamic>.from(json["groupInvites"].map((x) => x)),
    groups: List<dynamic>.from(json["groups"].map((x) => x)),
    lastName: json["lastName"],
    login: json["login"],
    otp: json["otp"],
    public: json["public"],
    size: json["size"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "_accessLevel": accessLevel,
    "_id": id,
    "_modelType": modelType,
    "admin": admin,
    "created": created.toIso8601String(),
    "email": email,
    "emailVerified": emailVerified,
    "firstName": firstName,
    "groupInvites": List<dynamic>.from(groupInvites.map((x) => x)),
    "groups": List<dynamic>.from(groups.map((x) => x)),
    "lastName": lastName,
    "login": login,
    "otp": otp,
    "public": public,
    "size": size,
    "status": status,
  };
}
