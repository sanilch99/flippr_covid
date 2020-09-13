// To parse this JSON data, do
//
//     final medicalCollege = medicalCollegeFromJson(jsonString);

import 'dart:convert';

MedicalCollege medicalCollegeFromJson(String str) => MedicalCollege.fromJson(json.decode(str));

String medicalCollegeToJson(MedicalCollege data) => json.encode(data.toJson());

class MedicalCollege {
  MedicalCollege({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  Data data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory MedicalCollege.fromJson(Map<String, dynamic> json) => MedicalCollege(
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
    this.medicalColleges,
    this.sources,
  });

  List<MedicalCollegeElement> medicalColleges;
  List<String> sources;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    medicalColleges: List<MedicalCollegeElement>.from(json["medicalColleges"].map((x) => MedicalCollegeElement.fromJson(x))),
    sources: List<String>.from(json["sources"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "medicalColleges": List<dynamic>.from(medicalColleges.map((x) => x.toJson())),
    "sources": List<dynamic>.from(sources.map((x) => x)),
  };
}

class MedicalCollegeElement {
  MedicalCollegeElement({
    this.state,
    this.name,
    this.city,
    this.ownership,
    this.admissionCapacity,
    this.hospitalBeds,
  });

  String state;
  String name;
  String city;
  Ownership ownership;
  int admissionCapacity;
  int hospitalBeds;

  factory MedicalCollegeElement.fromJson(Map<String, dynamic> json) => MedicalCollegeElement(
    state: json["state"],
    name: json["name"],
    city: json["city"],
    ownership: json["ownership"] == null ? null : ownershipValues.map[json["ownership"]],
    admissionCapacity: json["admissionCapacity"],
    hospitalBeds: json["hospitalBeds"],
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "name": name,
    "city": city,
    "ownership": ownership == null ? null : ownershipValues.reverse[ownership],
    "admissionCapacity": admissionCapacity,
    "hospitalBeds": hospitalBeds,
  };
}

enum Ownership { GOVT, TRUST, SOCIETY, UNIVERSITY, GOVT_SOCIETY, PRIVATE, OWNERSHIP_GOVT, OWNERSHIP_SOCIETY }

final ownershipValues = EnumValues({
  "Govt.": Ownership.GOVT,
  "Govt-Society": Ownership.GOVT_SOCIETY,
  "Govt": Ownership.OWNERSHIP_GOVT,
  "society": Ownership.OWNERSHIP_SOCIETY,
  "Private": Ownership.PRIVATE,
  "Society": Ownership.SOCIETY,
  "Trust": Ownership.TRUST,
  "University": Ownership.UNIVERSITY
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
