// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

Notifications notificationsFromJson(String str) => Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  Notifications({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  Data data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    lastRefreshed: DateTime.parse(json["lastRefreshed"]),
    lastOriginUpdate: DateTime.parse(json["lastOriginUpdate"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "lastRefreshed": lastRefreshed.toIso8601String(),
    "lastOriginUpdate": lastOriginUpdate.toIso8601String(),
  };
}

class Data {
  Data({
    this.notifications,
  });

  List<Notification> notifications;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: List<Notification>.from(json["notifications"].map((x) => Notification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notifications": List<dynamic>.from(notifications.map((x) => x.toJson())),
  };
}

class Notification {
  Notification({
    this.title,
    this.link,
  });

  String title;
  String link;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    title: json["title"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "link": link,
  };
}
