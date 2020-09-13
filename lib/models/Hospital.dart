// To parse this JSON data, do
//
//     final hospital = hospitalFromJson(jsonString);

import 'dart:convert';

Hospital hospitalFromJson(String str) => Hospital.fromJson(json.decode(str));

String hospitalToJson(Hospital data) => json.encode(data.toJson());

class Hospital {
  Hospital({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  Data data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
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
    this.summary,
    this.sources,
    this.regional,
  });

  Summary summary;
  List<Source> sources;
  List<Summary> regional;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    summary: Summary.fromJson(json["summary"]),
    sources: List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
    regional: List<Summary>.from(json["regional"].map((x) => Summary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "summary": summary.toJson(),
    "sources": List<dynamic>.from(sources.map((x) => x.toJson())),
    "regional": List<dynamic>.from(regional.map((x) => x.toJson())),
  };
}

class Summary {
  Summary({
    this.state,
    this.ruralHospitals,
    this.ruralBeds,
    this.urbanHospitals,
    this.urbanBeds,
    this.totalHospitals,
    this.totalBeds,
    this.asOn,
  });

  String state;
  int ruralHospitals;
  int ruralBeds;
  int urbanHospitals;
  int urbanBeds;
  int totalHospitals;
  int totalBeds;
  DateTime asOn;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    state: json["state"] == null ? null : json["state"],
    ruralHospitals: json["ruralHospitals"],
    ruralBeds: json["ruralBeds"],
    urbanHospitals: json["urbanHospitals"],
    urbanBeds: json["urbanBeds"],
    totalHospitals: json["totalHospitals"],
    totalBeds: json["totalBeds"],
    asOn: json["asOn"] == null ? null : DateTime.parse(json["asOn"]),
  );

  Map<String, dynamic> toJson() => {
    "state": state == null ? null : state,
    "ruralHospitals": ruralHospitals,
    "ruralBeds": ruralBeds,
    "urbanHospitals": urbanHospitals,
    "urbanBeds": urbanBeds,
    "totalHospitals": totalHospitals,
    "totalBeds": totalBeds,
    "asOn": asOn == null ? null : asOn.toIso8601String(),
  };
}

class Source {
  Source({
    this.url,
    this.lastUpdated,
  });

  String url;
  DateTime lastUpdated;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    url: json["url"],
    lastUpdated: DateTime.parse(json["lastUpdated"]),
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "lastUpdated": lastUpdated.toIso8601String(),
  };
}
